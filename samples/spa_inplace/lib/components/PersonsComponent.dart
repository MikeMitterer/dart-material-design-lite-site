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

/// Basic DI configuration for [PersonsComponent]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new PersonsComponentModule());
///         }     
///     }
class PersonsComponentModule  extends di.Module {
    PersonsComponentModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 

/// Controller for <sample-inplace-persons></sample-inplace-persons>
///
@MdlComponentModel
class PersonsComponent extends MdlComponent implements ScopeAware {
    final Logger _logger = new Logger('mdl_inplace_edit_sample.components.PersonsComponent');

    //static const _PersonsComponentConstant _constant = const _PersonsComponentConstant();
    static const _PersonsComponentCssClasses _cssClasses = const _PersonsComponentCssClasses();

    Scope scope;

    final ObservableList<Person> persons = new ObservableList<Person>();

    PersonsComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : super(element,injector) {

        scope = new Scope(this,mdlParentScope(this));

        persons.add(new Person("Marilyn","Monroe",36, """
            Marilyn Monroe (1926-1962) Model, actress, singer and arguably
            one of the most famous women of the twentieth century.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new Person("Abraham","Lincoln",56, """
            Abraham Lincoln was born Feb 12, 1809, in Hardin Country, Kentucky.
            His family upbringing was modest; his parents from Virginia were neither wealthy or well known.
            At an early age, the young lincolnAbraham lost his mother and his father moved away to Indiana.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        persons.add(new Person("Agnes","Gonxha Bojaxhiu",87, """
            Mother Teresa (1910-1997) was a Roman Catholic nun, who devoted her life to serving
            the poor and destitute around the world. She spent many years in Calcutta,
            India where shed founded the Missionaries of Charity, a religious congregation
            devoted to helping those in great need.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        _init();
        
    }
    
    static PersonsComponent widget(final dom.HtmlElement element) => mdlComponent(element,PersonsComponent) as PersonsComponent;
    
    // Central Element - by default this is where sample-inplace-persons can be found (element)
    // html.Element get hub => inputElement;
    
    // - EventHandler -----------------------------------------------------------------------------

    void handleButtonClick() {
        _logger.info("Event: handleButtonClick");
    }    
    
    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("PersonsComponent - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG!
        element.classes.add(_PersonsComponentConstant.WIDGET_SELECTOR);
        
//        final dom.DivElement sample = new dom.DivElement();
//        sample.text = "Your PersonsComponent-Component works!";
//        element.append(sample);
        
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
            (final dom.HtmlElement element,final di.Injector injector) => new PersonsComponent.fromElement(element,injector)
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