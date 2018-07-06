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
     
part of mdl_inplace_edit_sample.model;

@Model @mustache
class Person {
    // final Logger _logger = new Logger('mdl_inplace_edit_sample.model.Person');

    final String id;

    String firstname;
    String lastname;
    int age;
    String bio;

    Person(this.firstname,this.lastname,this.age,this.bio) : id = new Uuid().v1();

    Person.from(final Person person) : firstname = person.firstname, lastname = person.lastname,
        age = person.age, bio = person.bio, id = person.id;

//    bool operator==(final Person otherPerson) {
//        return id == otherPerson.id
//            && firstname == otherPerson.firstname
//            && lastname == otherPerson.lastname
//            && age == otherPerson.age
//            && bio == otherPerson.bio;
//    }

    /// Updates the current person with the incoming [Person] data.
    ///
    /// Must be the same ID!!!!
    void update(final Person person) {
        Validate.isTrue(id == person.id);
        firstname = person.firstname;
        lastname = person.lastname;
        age = person.age;
        bio = person.bio;
    }

    //- private -----------------------------------------------------------------------------------
}
