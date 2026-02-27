$(document).ready(function () {
    // Elimina el antiguo elemento <li> con la clase 'current'
    $('#nav li.current').removeClass('current');

    // Obtén la página actual sin la ruta base
    var currentPage = window.location.pathname.replace(/^.*[\\\/]/, '');
    console.log('Current Page:', currentPage);

    // Busca el <li> que contiene un enlace con el atributo 'href' que contiene la URL de la página actual
    var currentLi = $('#nav li:has(a[href*="' + currentPage + '"])');

    // Agrega la clase 'current' al <li> actual
    currentLi.addClass('current');

    // Busca y agrega la clase 'current' a todos los padres <li> del <li> actual
    currentLi.parents('li').addClass('current');
});
