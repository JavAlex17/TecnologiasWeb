// Guia 1 Ejercicio 1
// Nombre: Javiera Cabezas

var numero = prompt('Ingrese un número:');
var sumapar = 0;
    for (var i = 1; i <= numero; i++) {
        if (i % 2 == 0) {
                sumapar += i;
        }
    }

window.alert('La suma de los numeros pares desde el 1 hasta el ' + numero + ' es ' + sumapar);