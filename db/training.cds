namespace com.training;

// // Tipo matriz o array
// type EmailsAddresses_01 : array of {
//     kind  : String;
//     email : String;
// }

// // Tipo estructurado que luego se convierte en array más adelante
// type EmailsAddresses_02 {
//     kind  : String;
//     email : String;
// }

// entity Emails {
//     email_01 : EmailsAddresses_01; // Array
//     email_02 : many EmailsAddresses_02; // Estructurado que con many se convierte en array
//     email_03 : many {
//             kind  : String;
//             email : String;
//     } // Otra forma para representar un array
// }

// type Gender: String enum { //Op. 1: Limitamos a male y female
//     male;
//     female;
// };

// entity Order {
//     clientgender : Gender;
//     status: Integer enum{ //Op. 2: Le decimos que si entra un 1 va a ser submitted
//         submitted = 1;
//         fulfiller = 2;
//         shipped = 3;
//         cancel = -1;
//     };
//     priority : String @assert.range enum { // Op. 3: Limitamos a high, medium y low pero sin cambiar el tipo de dato
//         high;
//         medium;
//         low;
//     }
// }

// entity Car {
//     key ID                 : UUID;
//         name               : String;
//         virtual discount_1 : Decimal;
//         @Core.Computed : false
//         virtual discount_2 : Decimal;
// }