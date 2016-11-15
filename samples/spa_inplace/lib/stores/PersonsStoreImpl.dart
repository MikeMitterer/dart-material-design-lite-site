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

part of mdl_inplace_edit_sample.stores;

/// Concrete implementation for our stores.
///
/// We could use two separate implementations for each store but as you can see here,
/// for simplicity we use one store for the whole Application
class PersonsStoreImpl extends Dispatcher implements PersonsStore, PersonStore {
    final Logger _logger = new Logger('mdl_inplace_edit_sample.stores.PersonsStoreImpl');

    final ObservableList<Person> _persons = new ObservableList<Person>();

    PersonsStoreImpl(final ActionBus actionbus) : super(actionbus) {
        Validate.notNull(actionbus);

        _logger.info("PersonsStoreImpl - CTOR");

        _initSampleData();
        _bindSignals();
        _bindActions();
        _initTimer();
    }

    //- public interfaces -------------------------------------------------------------------------

    ObservableList<Person> get persons => _persons;

    /// Returns a NEW [Person] object - we don't want
    /// to modify Store-Objects directly!
    Person byId(final String uuid) {
        Validate.isUUID(uuid);
        return new Person.from(_byId(uuid));
    }

    String get time {
        return new DateFormat.Hms().format(new DateTime.now());
    }

    //- private -----------------------------------------------------------------------------------

    void _bindActions() {
        on(PersonChangedAction.NAME)
            .map((final Action action) => action as PersonChangedAction).listen((final PersonChangedAction action) {

            final Person newPerson = action.data;
            final Person oldPerson = _byId(newPerson.id);

            oldPerson.update(newPerson);
            emitChange();
        });
    }

    /// Internal [Person] object - can be modified
    Person _byId(final String uuid) {
        Validate.isUUID(uuid);
        return _persons.firstWhere((final Person person) => person.id == uuid);
    }

    void _bindSignals() {
    }

    void _initSampleData() {
        _persons.add(new Person("Marilyn","Monroe",36, """
            Marilyn Monroe (1926-1962) Model, actress, singer and arguably
            one of the most famous women of the twentieth century.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        _persons.add(new Person("Abraham","Lincoln",56, """
            Abraham Lincoln was born Feb 12, 1809, in Hardin Country, Kentucky.
            His family upbringing was modest; his parents from Virginia were neither wealthy or well known.
            At an early age, the young lincolnAbraham lost his mother and his father moved away to Indiana.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));

        _persons.add(new Person("Agnes","Gonxha Bojaxhiu",87, """
            Mother Teresa (1910-1997) was a Roman Catholic nun, who devoted her life to serving
            the poor and destitute around the world. She spent many years in Calcutta,
            India where shed founded the Missionaries of Charity, a religious congregation
            devoted to helping those in great need.
        """.trim().replaceAll(new RegExp(r"\s+")," ")));
    }

    /// For demonstration purpose - pump update-messages to the
    /// attached stores
    void _initTimer() {
        new Timer.periodic(new Duration(seconds: 1), (_) => emitChange(action: new UpdateTimeView()));
    }
}
