function highlightCurrentNav() {
    if (!$('#nav').length) return;
    $('#nav li.current').removeClass('current');
    var path = window.location.pathname;
    var currentPage = path.replace(/^.*[\\\/]/, '') || 'index.html';
    var currentLi = $('#nav li:has(a[href*="' + currentPage + '"])').first();
    if (!currentLi.length && (path === '/' || path.endsWith('/index.html'))) {
        currentLi = $('#nav li:has(a[href="/"])').first();
    }
    currentLi.addClass('current');
    currentLi.parents('li').addClass('current');
}

$(document).ready(highlightCurrentNav);
$(document).on('nav-ready', highlightCurrentNav);
