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
     
library mdl_inplace_edit_sample.stores;

import 'dart:async';

import 'package:dice/dice.dart' as di;
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';
import 'package:intl/intl.dart';

import 'package:mdl/mdl.dart';

import 'package:mdl_inplace_edit_sample/components/interfaces/stores.dart';
import 'package:mdl_inplace_edit_sample/components/interfaces/actions.dart';

import 'package:mdl_inplace_edit_sample/model.dart';

part 'stores/PersonsStoreImpl.dart';

PersonsStore _singletonStore = null;

/// Basic DI configuration for the Application-[DataStore]s
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new StoreModule());
///         }
///     }
class StoreModule  extends di.Module {
    configure() {
        register(PersonsStore).toInstance(_singletonFactory());
        register(PersonStore).toInstance(_singletonFactory());
    }
}

/// Ugly hack because DI does not support "asSingleton" like Guice does!!!!
_singletonFactory() {
    if(_singletonStore == null) {
        _singletonStore = new PersonsStoreImpl(new ActionBus());
    }
    return _singletonStore;
}