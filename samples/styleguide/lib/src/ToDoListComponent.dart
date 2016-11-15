/**
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 *
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of mdl_todo_sample.components;

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _ToDoListComponentCssClasses {

    static const String MAIN_CLASS  = "todo-list";

    final String IS_UPGRADED = 'is-upgraded';

    const _ToDoListComponentCssClasses();
}


class ModelChangedEvent {
    final ToDoItem item;
    ModelChangedEvent(this.item);
}

@MdlComponentModel
class ToDoListComponent extends MdlTemplateComponent implements ScopeAware {
    final Logger _logger = new Logger('todo.ToDoListComponent');

    static const _ToDoListComponentCssClasses _cssClasses = const _ToDoListComponentCssClasses();

    final ObservableList<ToDoItem> items = new ObservableList<ToDoItem>();
    final ToDoListStoreInterface _datastore;

    ToDoListComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _datastore = injector.get(ToDoListStoreInterface),super(element,injector) {
        _init();
    }

    static ToDoListComponent widget(final dom.HtmlElement element) => mdlComponent(element,ToDoListComponent) as ToDoListComponent;


    void onRemove(final String id) {
        _logger.info("Remove $id");
        final ToDoItem item = _getItem(id);
        _datastore.fire(new RemoveItemAction(item));
    }

    void onCheck(final String id) {
        _logger.info("Check $id");

        final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelector("#check${id.trim()}"));
        final ToDoItem item = _getItem(id);
        item.checked = checkbox.checked;
        _datastore.fire(new ItemCheckedAction(item));
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("ToDoItem - init");

        _render().then((_) => _bindSignals() );

        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    ToDoItem _getItem(final String id) {
        for(int counter = 0;counter < items.length;counter++) {
            if(items[counter].id == int.parse(id)) {
                return items[counter];
            }
        }
        return null;
    }

    Future _render() async {
        Stopwatch stopwatch = new Stopwatch()..start();

        await render();
        stopwatch.stop();

        final String message = "Data rendered with TemplateRenderer (${items.length}), "
            "took ${stopwatch.elapsedMilliseconds}ms";

        _logger.info(message);
    }

    void _bindSignals() {
        _datastore.onChange.listen( (_) {
            // Remove deleted items
            items.removeWhere((final ToDoItem item) => (!_datastore.items.contains(item)));

            // Add new items
            _datastore.items.forEach((final ToDoItem item) {
                if(!items.contains(item)) {
                    items.add(item);
                }
                // and update its checked-state
                final MaterialCheckbox checkbox = MaterialCheckbox.widget(element.querySelector("#check${item.id}"));
                if(checkbox != null) {
                    checkbox.checked = item.checked;
                }
            });
        });
    }

    //- Template -----------------------------------------------------------------------------------

    @override
    String template = """
        <div mdl-repeat="item in items">
            {{! ----- Turn off default mustache interpretation ---- }} {{= | | =}}
            <template>
                <div class="row">
                    <label class="mdl-checkbox mdl-ripple-effect" for="check{{item.id}}">
                        {{#item.checked}}
                            <input type="checkbox" id="check{{item.id}}" class="mdl-checkbox__input" checked data-mdl-click="check({{item.id}})"/>
                        {{/item.checked}}
                        {{^item.checked}}
                            <input type="checkbox" id="check{{item.id}}" class="mdl-checkbox__input" data-mdl-click="onCheck({{item.id}})"/>
                        {{/item.checked}}
                        <span class="mdl-checkbox__label">{{item.name}}</span>
                    </label>
                    <button class="mdl-button mdl-button--colored mdl-ripple-effect"
                        data-mdl-click="onRemove({{item.id}})">
                        Remove
                    </button>
                </div>
            </template>
            |= {{ }} =| {{! ----- Turn on mustache ---- }}
        </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");
}

/// registration-Helper
void registerToDoListComponent() {
    final MdlConfig config = new MdlWidgetConfig<ToDoListComponent>(
        _ToDoListComponentCssClasses.MAIN_CLASS,
            (final dom.HtmlElement element, final di.Injector injector) => new ToDoListComponent.fromElement(element, injector));

    config.selectorType = SelectorType.TAG;

    componentHandler().register(config);
}
