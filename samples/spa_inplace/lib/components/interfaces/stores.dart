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

library mdl_inplace_edit_sample.components.interfaces.stores;

import 'package:dice/dice.dart' as di;
import 'package:mdl/mdl.dart';

import 'package:mdl_inplace_edit_sample/model.dart';

@di.injectable
abstract class PersonsStore extends DataStore {

    /// Holds the persons for this sample!
    ObservableList<Person> get persons;
}

@di.injectable
abstract class PersonStore extends DataStore {

    /// This is returns the Person we want to edit
    Person byId(final String uuid);

    /// Just to demonstrate the update frequency!
    String get time;
}