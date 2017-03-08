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

library mdl_repeat_callback_sample.datastore;


import 'package:mdl/mdl.dart';
import 'package:mdl_repeat_callback_sample/components/interfaces.dart';
import 'package:di/di.dart' as di;

@di.Injectable()
class SampleStoreImpl extends Dispatcher implements SampleStore {

    final List<RandomItem> _items = new List<RandomItem>();

    SampleStoreImpl(final ActionBus actionbus) : super(actionbus) {
        _bindActions();
    }

    @override
    List<RandomItem> get items => _items;

    // - private -------------------------------------------------------------------------------------------------------

    void _bindActions() {
        on(ModelChangedAction.NAME)
            .map((final Action action) => action as ModelChangedAction)
            .listen((final ModelChangedAction action) {

            _items.clear();
            _items.addAll(action.data);
            emitChange();
        });
    }
}