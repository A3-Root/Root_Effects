#undef PREP
#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fn,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction

PREP(moduleNewsArticle);
PREP(moduleNewsArticle3DEN);
PREP(showArticleLocal);
PREP(openArticle);
