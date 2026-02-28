/*
	Arcana by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

(function ($) {

	var $window = $(window),
		$body = $('body');

	// Breakpoints.
	breakpoints({
		wide: ['1281px', '1680px'],
		normal: ['981px', '1280px'],
		narrow: ['841px', '980px'],
		narrower: ['737px', '840px'],
		mobile: ['481px', '736px'],
		mobilep: [null, '480px']
	});

	// Play initial animations on page load.
	$window.on('load', function () {
		window.setTimeout(function () {
			$body.removeClass('is-preload');
		}, 100);
	});

	// Inicialización del menú (también cuando se carga por AJAX en index)
	function initNav() {
		var $nav = $('#nav');
		if (!$nav.length) return;
		$nav.find('> ul').dropotron({
			offsetY: -15,
			hoverDelay: 0,
			alignment: 'left'
		});
		if ($('#titleBar').length) return; // Ya creado
		$(
			'<div id="titleBar">' +
			'<a href="#navPanel" class="toggle"></a>' +
			'<span class="title">IMPISI SPA </span>' +
			'</div>'
		).appendTo($body);
		$(
			'<div id="navPanel">' +
			'<nav>' +
			$nav.navList() +
			'</nav>' +
			'</div>'
		).appendTo($body).panel({
			delay: 500,
			hideOnClick: true,
			hideOnSwipe: true,
			resetScroll: true,
			resetForms: true,
			side: 'left',
			target: $body,
			visibleClass: 'navPanel-visible'
		});
	}

	$(function () { initNav(); });
	$(document).on('nav-ready', function () { initNav(); });

})(jQuery);

function enviarFormulario(event) {
    // Prevenir el envío tradicional del formulario
    event.preventDefault();
    
    // Obtener el formulario
    var form = event.target;
    
    // Mostrar el popup
    var popup = document.getElementById("popup");
    popup.style.display = "block";

    // Enviar con AJAX
    fetch(form.action, {
        method: 'POST',
        body: new FormData(form),
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Error en la respuesta del servidor');
        }
        return response.json();
    })
    .then(data => {
        console.log('Respuesta recibida:', data); // Para debugging
        
        // FormSubmit devuelve success como string "true" o "false"
        if (data.success === "true") {
            // Éxito: ocultar popup después de 2 segundos y limpiar formulario
            setTimeout(function () {
                popup.style.display = "none";
                form.reset(); // Limpiar formulario
                // Opcional: mostrar mensaje de éxito adicional
            }, 2000);
        } else {
            // Error del servidor
            popup.style.display = "none";
            alert('Error: ' + (data.message || 'No se pudo enviar el mensaje'));
        }
    })
    .catch(error => {
        console.error('Error en fetch:', error);
        popup.style.display = "none";
        alert('Error de conexión: ' + error.message);
    });
    
    // Importante: return false para prevenir el envío tradicional
    return false;
}
