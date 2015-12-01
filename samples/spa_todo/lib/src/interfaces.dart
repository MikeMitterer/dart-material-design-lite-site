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

library mdl_todo_sample.components.interfaces;

import "package:mdl/mdlcore.dart";
import "package:mdl/mdlflux.dart";
import 'dart:collection';

// - DataStores for our components -------------------------------------------------------------------------------------

abstract class ToDoInputStoreInterface extends DataStore {
    int get nrOfItemsDone;
    int get nrOfItems;
}

abstract class ToDoListStoreInterface extends DataStore {
    UnmodifiableListView<ToDoItem> get items;
}

// - Actions sent by our app -------------------------------------------------------------------------------------------

class AddItemAction extends DataAction<ToDoItem> {
    static const ActionName NAME = const ActionName("mdl_todo_sample.components.interfaces.AddItemAction");
    const AddItemAction(final ToDoItem item) : super(NAME,item);
}

class ItemCheckedAction extends DataAction<ToDoItem> {
    static const ActionName NAME = const ActionName("mdl_todo_sample.components.interfaces.ItemCheckedAction");
    const ItemCheckedAction(final ToDoItem item) : super(NAME,item);
}

class RemoveItemAction extends DataAction<ToDoItem> {
    static const ActionName NAME = const ActionName("mdl_todo_sample.components.interfaces.RemoveItemAction");
    const RemoveItemAction(final ToDoItem item) : super(NAME,item);
}

/// TransferObject (TO) for this little app.
///
/// MdlComponentModel is needed because we use this class (object)
/// in a (mustache) rendering process
@MdlComponentModel
class ToDoItem {
    static int counter = 0;
    int id;

    bool checked;
    final String name;

    ToDoItem(this.checked, this.name) : id = counter { counter++; }
}