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
     
library mdl_inplace_edit_sample.components;

import 'dart:html' as dom;
import 'dart:async';

import 'package:dryice/dryice.dart';
import 'package:mustache/mustache.dart';

import 'package:logging/logging.dart';
import 'package:mdl/mdl.dart';
import 'package:mdl/mdlanimation.dart';

import 'package:mdl_inplace_edit_sample/model.dart';
import 'package:mdl_inplace_edit_sample/components/interfaces/stores.dart';
import 'package:mdl_inplace_edit_sample/components/interfaces/actions.dart';

part 'components/NameEditComponent.dart';
part 'components/PersonsComponent.dart';

final MdlAnimation expandAnimation = new MdlAnimation.keyframes(
    <int, Map<String, Object>>{
        0 : const <String, Object>{
            "margin" : "8px 24px 8px 24px" },

        100 : const <String, Object>{
            "margin" : "24px 4px 24px 4px"}
    });

final MdlAnimation shrinkAnimation = new MdlAnimation.keyframes(
    <int, Map<String, Object>>{
        0 : const <String, Object>{
            "margin" : "24px 4px 24px 4px" },

        100 : const <String, Object>{
            "margin" : "8px 24px 8px 24px"}
    });

final MdlAnimation fadeOut = new MdlAnimation.fromStock(StockAnimation.FadeOut);

void registerInplaceSampleComponents() {
    registerNameEditComponent();
    registerPersonsComponent();
}