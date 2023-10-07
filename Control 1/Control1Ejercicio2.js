// Pregunta 2
// Nombre: Javiera Cabezas

var frase = prompt('Ingrese una Frase:');
var letra = prompt('Ingrese una letra:');
var cantidad = 0

for (var i = 0; i <= frase.length; i++){
    if (letra == frase[i]){
        cantidad += 1;
    }
}
window.alert('La letra '+ letra + ' aparece '+ cantidad + ' veces en la frase: ' + frase);