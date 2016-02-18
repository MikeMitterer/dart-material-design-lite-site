/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
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
     
part of mdl_inplace_edit_sample.components;
 
/// Basic DI configuration for this Component or Service
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new NameEditComponentModule());
///         }     
///     }
class NameEditComponentModule  extends di.Module {
    NameEditComponentModule() {
        // bind(DeviceProxy);
    }
} 

/// Controller for <name-editor></name-editor>
///
@MdlComponentModel
class NameEditComponent extends MdlTemplateComponent {
    final Logger _logger = new Logger('mdl_inplace_edit_sample.components.NameEditComponent');

    //static const _NameEditComponentConstant _constant = const _NameEditComponentConstant();
    static const _NameEditComponentCssClasses _cssClasses = const _NameEditComponentCssClasses();

    /// With [_active] we decide which template to render
    bool _active = false;

    /// Only a single person is necessary
    final PersonStore _store;

    NameEditComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector), _store = injector.get(PersonStore) {
        
        _init();
    }
    
    static NameEditComponent widget(final dom.HtmlElement element) => mdlComponent(element,NameEditComponent) as NameEditComponent;

    // - Used for Template rendering --------------------------------------------------------------

    String get id => element.dataset["id"];

    String get time => _store.time;

    String get firstname => _store.byId(id).firstname;

    String get lastname => _store.byId(id).lastname;

    int get age => _store.byId(id).age;

    String get bio => _store.byId(id).bio;

    String get firstCharacter {
        final String firstname = _store.byId(id).firstname;
        return firstname.isNotEmpty ? firstname.substring(0,1).toUpperCase() : "";
    }

    String get iconcolor => _colorName(firstCharacter);

    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick(final dom.Event event) {
        event.preventDefault();

        _active = !_active;

        if(_active) {

            render().then((_) {
                element.classes.add(_cssClasses.ACTIVE);
                _bindFormActions();

                new Future.delayed(new Duration(milliseconds: 50),() {
                    // Avoid title flickering
                    element.querySelector(".${_cssClasses.CONTAINER}").style.removeProperty("opacity");
                });
            });

        } else {
            render().then((_) {
                element.classes.remove(_cssClasses.ACTIVE);
            });
        }
    }

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.fine("NameEditComponent - init");
        
        // Recommended - add SELECTOR as class
        element.classes.add(_NameEditComponentConstant.WIDGET_SELECTOR);
        
        render().then((_) {
            _bindActions();
        });
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }

    /// After the template is rendered we bind all the necessary events for this component
    void _bindActions() {
        _store.onChange.listen((final DataStoreChangedEvent event) {
            // This message comes every second - so we optimize this update section a bit
            if(event.data.actionname == UpdateTimeView.NAME) {
                _updateTime();

            } else {

                _updateView(_store.byId(id));
            }
        });
    }

    /// Form is only available in the active (open) template
    /// so this function is called if we render the active (expanded) template
    void _bindFormActions() {
        //final MaterialFormComponent form = MaterialFormComponent.widget(element.querySelector(".mdl-form"));

        _updateStore() {
            // Create new Person - we don't want to edit the "Store person"!
            final Person person = _store.byId(id);

            person.firstname = _firstname.value;
            person.lastname = _lastname.value;

            try {
                person.age = int.parse(_age.value);
            } on FormatException {
                person.age = 0;
            }
            person.bio = _bio.value;

            _store.fire(new PersonChangedAction(person));
        }

        _firstname.hub.onChange.listen((_) => _updateStore());
        _lastname.hub.onChange.listen((_) => _updateStore());
        _age.hub.onChange.listen((_) => _updateStore());
        _bio.hub.onChange.listen((_) => _updateStore());
    }

    MaterialTextfield get _firstname => MaterialTextfield.widget(element.querySelector("#firstname"));
    MaterialTextfield get _lastname => MaterialTextfield.widget(element.querySelector("#lastname"));
    MaterialTextfield get _age => MaterialTextfield.widget(element.querySelector("#age"));
    MaterialTextfield get _bio => MaterialTextfield.widget(element.querySelector("#bio"));
    dom.HtmlElement get _title => element.querySelector(".${_cssClasses.TITLE}");

    /// Something has changed - visualize it
    ///
    /// Usually this function is called if we get an onChange-event from our store
    void _updateView(final Person person) {
        _firstname?.value = person.firstname;
        _lastname?.value = person.lastname;
        _age?.value = person.age.toString();
        _bio?.value = person.bio;

        if(person.firstname.isNotEmpty && person.lastname.isNotEmpty && person.age != 0) {
            _title.text = "${person.firstname} ${person.lastname}, ${person.age}";
        } else {
            _title.text = "???";
        }

        dom.SpanElement icon = element.querySelector(".${_cssClasses.TITLE_ICON}");
        icon ??= element.querySelector(".${_cssClasses.CONTENT_ICON}");

        icon.text = firstCharacter;
        icon.classes.retainWhere((final String classname) => !classname.startsWith("mdl-"));
        icon.classes.add(_colorName(person.firstname));
    }

    void _updateTime() {
        element.querySelector(".${_cssClasses.TIME}").text = _store.time;
    }

    String _colorName(final String character) {
        final String firstCharacter = character.isNotEmpty ? character.substring(0,1).toLowerCase() : "";

        switch(firstCharacter.toLowerCase()) {
            case 'a':
            case 't':
                return 'mdl-color--red';
            case 'b':
            case 'u':
                return 'mdl-color--pink';
            case 'c':
            case 'v':
                return 'mdl-color--purple';
            case 'd':
            case 'w':
                return 'mdl-color--deep-purple';
            case 'e':
            case 'x':
                return 'mdl-color--indigo';
            case 'f':
            case 'y':
                return 'mdl-color--blue';
            case 'g':
            case 'z':
                return 'mdl-color--light-blue';
            case 'g':
                return 'mdl-color--cyan';
            case 'i':
                return 'mdl-color--teal';
            case 'j':
                return 'mdl-color--green';
            case 'k':
                return 'mdl-color--light-green';
            case 'l':
                return 'mdl-color--lime';
            case 'm':
            case 'n':
                return 'mdl-color--amber';
            case 'o':
                return 'mdl-color--orange';
            case 'p':
                return 'mdl-color--deep-orange';
            case 'q':
                return 'mdl-color--brown';
            case 'r':
                return 'mdl-color--grey';
            case 's':
                return 'mdl-color--blue-grey';
            default: return 'mdl-color--red';
        }

    }
    //- Template -----------------------------------------------------------------------------------
    
    @override
    String get template => _active ? _activeTemplate : _inactiveTemplate;

    final String _inactiveTemplate = """
        <div class="sample-inplace-edit__container">
            <div class="sample-inplace-edit__title" data-mdl-click="handleButtonClick(\$event)">
                <span class="sample-inplace-edit__title-icon {{iconcolor}}">{{firstCharacter}}</span>
                <span class="sample-inplace-edit__title-data">{{firstname}} {{lastname}}, {{age}}</span>
                <span class="sample-inplace-edit__title-time">{{time}}</span>
            </div>
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

    final String _activeTemplate = """
        <div class="sample-inplace-edit__container" style="opacity: 0;">
            <div class="sample-inplace-edit__title" data-mdl-click="handleButtonClick(\$event)">
                <span class="sample-inplace-edit__title-data">{{firstname}} {{lastname}}, {{age}}</span>
                <span class="sample-inplace-edit__title-time">{{time}}</span>
            </div>
            <section class="sample-inplace-edit__content">
                <span class="sample-inplace-edit__content-icon {{iconcolor}}">{{firstCharacter}}</span>
                <form action="#" class="mdl-form">
                    <div class="mdl-textfield mdl-js-textfield">
                        <input class="mdl-textfield__input" type="text" id="firstname" value="{{firstname}}" autofocus>
                        <label class="mdl-textfield__label" for="firstname">First name</label>
                    </div>
                    <div class="mdl-textfield mdl-js-textfield">
                        <input class="mdl-textfield__input" type="text" id="lastname" value="{{lastname}}">
                        <label class="mdl-textfield__label" for="lastname">Last name</label>
                    </div>
                    <div class="mdl-textfield mdl-js-textfield">
                        <input class="mdl-textfield__input" type="text" id="age" value="{{age}}">
                        <label class="mdl-textfield__label" for="age">Age</label>
                    </div>

                    <div class="mdl-textfield mdl-js-textfield" id="bio-textfield">
                        <textarea class="mdl-textfield__input" type="text" maxrows="5" rows="5" id="bio">{{bio}}</textarea>
                        <label class="mdl-textfield__label" for="bio">Bio</label>
                    </div>

                </form>
            </section>
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

}

/// Registers the NameEditComponent-Component
///
///     main() {
///         registerNameEditComponent();
///         ...
///     }
///
void registerNameEditComponent() {
    final MdlConfig config = new MdlWidgetConfig<NameEditComponent>(
        _NameEditComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new NameEditComponent.fromElement(element,injector)
    );
    
    // If you want <name-editor></name-editor> set selectorType to SelectorType.TAG.
    // If you want <div name-editor></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="name-editor"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _NameEditComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';

    final String ACTIVE = 'active';

    final String SHOW_CONTENT = 'show-content';

    final String CONTAINER = 'sample-inplace-edit__container';
    final String TIME = 'sample-inplace-edit__title-time';
    final String TITLE = 'sample-inplace-edit__title-data';

    final String TITLE_ICON = 'sample-inplace-edit__title-icon';
    final String CONTENT_ICON = 'sample-inplace-edit__content-icon';

    const _NameEditComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _NameEditComponentConstant {

    static const String WIDGET_SELECTOR = "sample-inplace-edit";

    const _NameEditComponentConstant();
}    