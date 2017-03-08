/*
 * Copyright (c) 2017, Michael Mitterer (office@mikemitterer.at),
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
     
part of mdl_repeat_callback_sample.components;
 
/* 
/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new WithCallbackComponentModule());
///         }     
///     }
class WithCallbackComponentModule  extends di.Module {
    WithCallbackComponentModule() {
        // bind(DeviceProxy);
    }
} 
*/

/// Controller-View for <with-callback></with-callback>
///
@MdlComponentModel
class WithCallbackComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdld_repeat_callback_sample.components.WithCallbackComponent');

    //static const _WithCallbackComponentConstant _constant = const _WithCallbackComponentConstant();
    static const _WithCallbackComponentCssClasses _cssClasses = const _WithCallbackComponentCssClasses();

    final ObservableList<RandomItem> items = new ObservableList<RandomItem>(
        updateCallback: _updateListItem);

    /// Here is our model
    final SampleStore _store;

    /// Output-Date-Formatter
    static final DateFormat _formatter = new DateFormat("yyyy.MM.dd HH.mm.ss");

    
    WithCallbackComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _store = injector.get(SampleStore), super(element,injector) {
        _init();
    }
    
    static WithCallbackComponent widget(final dom.HtmlElement element) => mdlComponent(element,WithCallbackComponent) as WithCallbackComponent;
    
    // Central Element - by default this is where with-callback can be found (element)
    // html.Element get hub => inputElement;
    
    // - Used for Template rendering --------------------------------------------------------------

    // Returns the given data-id
    //     <with-callback data-id="<your id>"></with-callback>
    // String get id => element.dataset["id"];

    // - EventHandler -----------------------------------------------------------------------------

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("WithCallbackComponent - init");
        
        // Recommended - add SELECTOR as class
        element.classes.add(_WithCallbackComponentConstant.WIDGET_SELECTOR);
        
        render().then((_) {
            _bindStoreActions();
            _bindViewActions();
        });
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
    
    /// After the template is rendered we bind all the necessary Actions for this component
    void _bindStoreActions() {
        // only after creation...
        if(_store == null) { return;}

        _store.onChange.listen((final DataStoreChangedEvent event) {

            // Handle specific Update-Actions
            // if(event.data.actionname == UpdateTimeView.NAME) {
            //
            // }

            _updateView();

        });
    }

    /// Something has changed in the attached store - visualize it
    ///
    /// Usually this function is called if we get an onChange-event from our store
    void _updateView() {
        _logger.fine("Store changed!");

        if(items.length != _store.items.length) {
            items.clear();
            items.addAll(_store.items);
        } else {
            final List<RandomItem> _storeRecords = _store.items;
            for (int index = 0; index < _storeRecords.length; index++) {
                items[index] = _storeRecords[index];
            }
        }
    }

    /// Attach Actions coming from our view (HTML-Template)
    void _bindViewActions() {
        
        // final MaterialFormComponent form = MaterialFormComponent.widget(query(".mdl-form"));
        //
        // eventStreams.add(
        //     form.onChange.listen((_) {
        //         // Create new Person - we don't want to edit the "Store person"!
        //         // final Person person = _store.byId(id);
        //
        //         // _store.fire(new PersonChangedAction(person));
        //     }));
    }

    /// Called if List-Items updates
    static bool _updateListItem(final dom.HtmlElement element, final RandomItem item) {
        if(element == null) {
            return false;
        }
        final dom.SpanElement date = element.querySelector(".date");
        final dom.SpanElement records = element.querySelector(".value");

        date.text = _formatter.format(item.date);
        records.text = item.value.toString();
        return true;
    }

    //- Template -----------------------------------------------------------------------------------

    @override
    final String template = """
        <div class="mdl-panel__content" mdl-repeat="item in items">
           {{! ----- Turn off default mustache interpretation (sitegen) ---- }} {{= | | =}}
            <template>
                <div>
                    <span class='date'>{{item.date}}</span>
                    <span class='value'>{{item.value}}</span>
                </div>
            </template>
           |= {{ }} =| {{! ----- Turn on mustache ---- }}
        </div>
        """.trim().replaceAll(new RegExp(r"\s+")," ");
}

/// Registers the WithCallbackComponent-Component
///
///     main() {
///         registerWithCallbackComponent();
///         ...
///     }
///
void registerWithCallbackComponent() {
    final MdlConfig config = new MdlWidgetConfig<WithCallbackComponent>(
        _WithCallbackComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new WithCallbackComponent.fromElement(element,injector)
    );
    
    // If you want <with-callback></with-callback> set selectorType to SelectorType.TAG.
    // If you want <div with-callback></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="with-callback"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _WithCallbackComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    const _WithCallbackComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _WithCallbackComponentConstant {

    static const String WIDGET_SELECTOR = "with-callback";

    const _WithCallbackComponentConstant();
}    