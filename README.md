# README

## Přehled projektu

Tento projekt se zaměřuje na analýzu vztahů mezi HDP, průměrnými mzdami a cenami potravin v České republice v průběhu let 2006 až 2018. Analýza je prováděna pomocí SQL dotazů, které odpovídají na různé ekonomické otázky a poskytují vhled do toho, jak HDP ovlivňuje mzdy a ceny potravin.

### Cíle projektu

Projekt si klade za cíl odpovědět na následující otázky:

1. **Rostou mzdy ve všech odvětvích v průběhu let, nebo v některých klesají?**
2. **Kolik litrů mléka a kilogramů chleba lze koupit za průměrnou mzdu v prvním a posledním srovnatelném období dostupných dat cen a mezd?**
3. **Která kategorie potravin zdražuje nejpomaleji (má nejnižší průměrný meziroční nárůst cen)?**
4. **Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**
5. **Má výška HDP vliv na změny ve mzdách a cenách potravin?**

### Popis datové sady

Datová sada použitá v tomto projektu pochází z databáze `t_rostislav_klech_project_sql_primary_final2`. Byly vybrány následující klíčové sloupce:

- **`payroll_year`**: Rok, ke kterému se data vztahují.
- **`average_payroll`**: Průměrná roční mzda pro jednotlivá odvětví.
- **`GDP`**: Hrubý domácí produkt České republiky, upravený tak, aby odpovídal měřítku a srovnání s průměrnými mzdami.
- **`name_industry`**: Název odvětví, ke kterému se průměrná mzda vztahuje.
- **`average_value_per_year`**: Průměrná roční cena potravinových produktů.
- **`name_product`**: Název potravinového produktu zahrnutého v datové sadě.

### Časový rozsah dat

Data zahrnují období let 2006 až 2018. Tento rozsah byl vybrán kvůli dostupnosti dat a chybějícím hodnotám v tabulce `czechia_price` pro jiné roky. Analýza a závěry se tedy vztahují pouze na tato časová období.

## Analýza a výsledky

### Otázka 1: Rostou mzdy ve všech odvětvích v průběhu let, nebo v některých klesají?

První dotaz používá SQL funkci `LAG` k porovnání roční průměrné mzdy s předchozím rokem pro každé odvětví. Výsledky ukázaly, že mzdy klesaly v některých letech, zejména v roce 2013 a 2010:

- **Rok 2013**: Pokles mezd byl zaznamenán například v odvětvích: Administrativní a podpůrné činnosti, Činnosti v oblasti nemovitostí, Informační a komunikační činnosti.
- **Rok 2010**: Pokles mezd byl zaznamenán v odvětvích: Profesní, vědecké a technické činnosti, Veřejná správa a obrana; povinné sociální zabezpečení.

Tato analýza ukazuje, že ačkoli mzdy v dlouhodobém horizontu vykazují rostoucí trend, existují krátkodobé poklesy v některých letech a odvětvích.

### Otázka 2: Kolik litrů mléka a kilogramů chleba lze koupit za průměrnou mzdu?

Tento dotaz vypočítává množství mléka a chleba, které lze zakoupit za průměrnou roční mzdu v letech 2006 a 2018, pomocí vzorce `average_payroll / average_value_per_year`. Výsledky ukázaly, že reálná kupní síla se u některých základních potravin zvýšila, což znamená, že za průměrnou mzdu je možné zakoupit větší množství potravin než dříve.

### Otázka 3: Která kategorie potravin zdražuje nejpomaleji?

Pomocí ročního procentuálního nárůstu cen byly identifikovány potraviny s nejnižším růstem cen. Výsledky ukázaly, že například **cukr** a **rajská jablka** v některých letech dokonce zlevňovaly. Potravina s nejpomalejším růstem cen byla identifikována jako **banány žluté**.

### Otázka 4: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

Výsledky analýzy ukázaly, že neexistuje rok, ve kterém by meziroční růst cen potravin převýšil růst mezd o více než 10 %. Tento výsledek naznačuje, že i když se ceny potravin mění, změny mezd v průměru tyto změny překonávají.

### Otázka 5: Má výška HDP vliv na změny ve mzdách a cenách potravin?

K zodpovězení této otázky byly použity dvě statistické metody:

1. **Korelační analýza**: Pearsonův korelační koeficient mezi růstem HDP a růstem mezd byl vypočítán jako **0,92036**, což značí silný pozitivní vztah. Korelační koeficient mezi růstem HDP a růstem cen potravin byl **0,88530**, což také ukazuje na silný pozitivní vztah, ale o něco slabší než u mezd.

2. **Regresní analýza**: Byla určena směrnice regresní přímky pro vztah mezi HDP a mzdami, která vyšla jako **0,0000000076757057**. To znamená, že i přes vysokou korelaci má změna HDP na mzdy minimální přímý vliv v absolutních hodnotách. Směrnice pro vztah mezi HDP a cenami potravin byla **0**, což znamená, že mezi HDP a cenami potravin neexistuje žádný lineární vztah.

## Doporučení pro další analýzu

Pro budoucí analýzy by bylo vhodné testovat jiné ekonomické indikátory, jako je míra inflace, úroveň nezaměstnanosti nebo zohlednit regionální rozdíly. Také by bylo možné zahrnout sezónní vlivy, aby se zjistilo, zda sezónnost ovlivňuje ceny potravin nebo mzdy v průběhu roku.

## Závěr

Tento projekt poskytl ucelený přehled o vztazích mezi HDP, mzdami a cenami potravin v České republice v letech 2006 až 2018. Výsledky ukazují, že HDP má silný vliv na růst mezd, zatímco jeho vliv na ceny potravin je mnohem slabší.

