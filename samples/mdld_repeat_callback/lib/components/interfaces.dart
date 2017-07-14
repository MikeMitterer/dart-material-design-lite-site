/*
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

library mdld_repeat_callback_sample.components.interfaces;

import 'package:dice/dice.dart' as di;
import "package:mdl/mdlcore.dart";
import "package:mdl/mdlflux.dart";

class RandomItem {
    final DateTime date;
    final int value;

    RandomItem(this.date, this.value);
}

// - DataStores for our components -------------------------------------------------------------------------------------

@di.injectable
abstract class SampleStore extends DataStore {
    List<RandomItem> get items;
}

// - Actions sent by our app -------------------------------------------------------------------------------------------

class ModelChangedAction extends DataAction<List<RandomItem>> {
    static const ActionName NAME = const ActionName("mdld_repeat_callback_sample.components.interfaces.ModelChangedAction");
    const ModelChangedAction(final List<RandomItem> items) : super(NAME,items);
}