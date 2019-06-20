/* ------------------------------------------------------------------------------------------------------------------ *\
 * http://api.jquery.com/category/selectors/                                                                          *
 * http://stackoverflow.com/questions/739695/jquery-selector-value-escaping/3113742#3113742                           *
\* ------------------------------------------------------------------------------------------------------------------ */

function nsicEscapeJQuerySelector(value) {
    return value.replace(/([#;&,.+*~':"!^$\[\]\(\)=>|\/@ ])/g,'\\$1');
}
