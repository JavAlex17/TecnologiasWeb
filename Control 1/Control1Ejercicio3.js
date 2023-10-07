// Pregunta 3
// Nombre: Javiera Cabezas

var nombre = prompt('Ingrese su Nombre de Usuario:');
var i = 0
var requisitos = 0

function cantidad(){
    if (nombre.length < 9){
        window.alert('El nombre no cumple con los requisitos(cantidad letras)');
    }
    if (nombre.length >= 9){
        requisitos += 1;
}
}


function primerNum () {
    if (i < 10){
        if (nombre[0] != i){
            i += 1;
            primerNum();
        }
        if (nombre[0] == i){
            requisitos += 1;
        }
    }
    if (i == 10){
        window.alert('El nombre no cumple con los requisitos(numero)');
        exit();
    }
}


function letras(){
    mayus = 0
    min = 0

    for (var i = 0; i <= nombre.length; i++){
        mayusc = nombre[i].toUpperCase();
        if (nombre[i] == mayusc){
            mayus += 1;
        }
        minus = nombre[i].toLowerCase();
        if (nombre[i] == minus){
            min += 1;
        }
    }
    if (mayus == 0){
        window.alert('El nombre no cumple con los requisitos(mayus)');
    }
    if (min == 0){
        window.alert('El nombre no cumple con los requisitos(min)');
    }
}


primerNum();
cantidad();
letras();