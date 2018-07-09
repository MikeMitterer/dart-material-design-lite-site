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

library mdl_todo_sample.datastore;

import 'dart:collection';

import 'package:mdl/mdl.dart';
import 'package:mdl_styleguide/src/interfaces.dart';
import 'package:dryice/dryice.dart';

@inject
class ToDoDataStore extends Dispatcher implements ToDoInputStoreInterface, ToDoListStoreInterface {

    final List<ToDoItem> _items = new List<ToDoItem>();

    ToDoDataStore(final ActionBus actionbus) : super(actionbus) {
        _bindSignals();
    }

    @override
    int get nrOfItems => _items.length;

    @override
    int get nrOfItemsDone =>
        _items
            .where((final ToDoItem item) => item.checked)
            .length;

    UnmodifiableListView<ToDoItem> get items => new UnmodifiableListView<ToDoItem>(_items);

    // - private -------------------------------------------------------------------------------------------------------

    void _bindSignals() {
        on(AddItemAction.NAME)
            .map((final Action action) => action as AddItemAction).listen((final AddItemAction action) {

            _items.add(action.data);
            emitChange();
        });

        on(ItemCheckedAction.NAME)
            .map((final Action action) => action as ItemCheckedAction).listen((final ItemCheckedAction action) {
            _items.forEach((final ToDoItem item) {
                if (item.id == action.data.id) {
                    item.checked = action.data.checked;
                }
            });
            emitChange();
        });

        on(RemoveItemAction.NAME)
            .map((final Action action) => action as RemoveItemAction).listen((final RemoveItemAction action) {
            _items.removeWhere((final ToDoItem item) => item.id == action.data.id);
            emitChange();
        });
    }
}