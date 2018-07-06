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

/// Controller for <sample-inplace-persons></sample-inplace-persons>
///
/// We make this component [ScopeAware] so that MaterialRepeat (mdl-repeat)
/// can use it!
@Component @inject @mustache
class PersonsComponent extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdl_inplace_edit_sample.components.PersonsComponent');

    static const _PersonsComponentCssClasses _cssClasses = const _PersonsComponentCssClasses();

    /// Holds all the persons for this sample
    final PersonsStore _store;

    Scope scope;

    PersonsComponent.fromElement(final dom.HtmlElement element,final Injector injector)
        : _store = injector.getInstance(PersonsStore), super(element,injector) {

        scope = new Scope(this,mdlParentScope(this));
        _init();
    }
    
    static PersonsComponent widget(final dom.HtmlElement element) => mdlComponent(element,PersonsComponent) as PersonsComponent;

    /// Make persons available for mdl-repeat
    ObservableList<Person> get persons => _store.persons;

    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("PersonsComponent - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG!
        element.classes.add(_PersonsComponentConstant.WIDGET_SELECTOR);
        
        element.classes.add(_cssClasses.IS_UPGRADED);
    }
}

/// Registers the PersonsComponent-Component
///
///     main() {
///         registerPersonsComponent();
///         ...
///     }
///
void registerPersonsComponent() {
    final MdlConfig config = new MdlWidgetConfig<PersonsComponent>(
        _PersonsComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final Injector injector) => new PersonsComponent.fromElement(element,injector)
    );
    
    // If you want <sample-inplace-persons></sample-inplace-persons> set selectorType to SelectorType.TAG.
    // If you want <div sample-inplace-persons></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="sample-inplace-persons"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _PersonsComponentCssClasses {

    final String IS_UPGRADED = 'is-upgraded';
    
    const _PersonsComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _PersonsComponentConstant {

    static const String WIDGET_SELECTOR = "sample-inplace-persons";

    const _PersonsComponentConstant();
}  