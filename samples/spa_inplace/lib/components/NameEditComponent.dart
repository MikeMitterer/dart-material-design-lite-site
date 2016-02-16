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

    NameEditComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {
        
        _init();
        
    }
    
    static NameEditComponent widget(final dom.HtmlElement element) => mdlComponent(element,NameEditComponent) as NameEditComponent;
    
    // Central Element - by default this is where name-editor can be found (element)
    // html.Element get hub => inputElement;
    
    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick(final dom.Event event) {
        event.preventDefault();
        _logger.info("Event: handleButtonClick");

        _active = !_active;

        element.classes.remove(_cssClasses.SHOW_CONTENT);

        if(_active) {
            element.classes.add(_cssClasses.ACTIVE);
            // CSS-Margin-Transition takes ~ 200ms
            render().then((_) => element.classes.add(_cssClasses.SHOW_CONTENT));
        } else {
            render().then((_) {
                element.classes.remove(_cssClasses.ACTIVE);
            });
        }

    }

    String get id => element.dataset["id"];

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("NameEditComponent - init");
        
        // Recommended - add SELECTOR as class
        element.classes.add(_NameEditComponentConstant.WIDGET_SELECTOR);
        
        render();
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
    
    //- Template -----------------------------------------------------------------------------------
    
    @override
    String get template => _active ? _activeTemplate : _inactiveTemplate;

    final String _inactiveTemplate = """
        <div class="sample-inplace-edit__title" data-mdl-click="handleButtonClick(\$event)">
            <span class="sample-inplace-edit__title-icon">A</span>{{id}}
        </div>
    """.trim().replaceAll(new RegExp(r"\s+")," ");

    final String _activeTemplate = """
        <div>
            <div class="sample-inplace-edit__title" data-mdl-click="handleButtonClick(\$event)">
                {{id}}
            </div>
            <section class="sample-inplace-edit__content">
                <span class="sample-inplace-edit__content-icon">A</span>
                <p>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
                tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero
                eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea
                takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur
                sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,
                sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.
                Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
                Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
                invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et
                justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem
                ipsum dolor sit amet.</p>
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

    const _NameEditComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _NameEditComponentConstant {

    static const String WIDGET_SELECTOR = "sample-inplace-edit";

    const _NameEditComponentConstant();
}    