//@TestOn("content-shell")
import 'package:test/test.dart';

// import 'package:logging/logging.dart';
import 'package:mdl_inplace_edit_sample/model.dart';

import '../config.dart';

main() async {
    // final Logger _logger = new Logger("test.Model");
    
    configLogging();
    //await saveDefaultCredentials();


    group('Model', () {
        setUp(() { });

        test('> Create Person from other Person', () {
            final Person p1 = new Person("Mike","Mitterer",49,"no bio");
            final Person p2 = new Person.from(p1);

            expect(p2,p1);
        }, skip: "Bug in mustache"); // end of 'Create Person from other Person' test

    });
    // End of 'Model' group
}

// - Helper --------------------------------------------------------------------------------------
