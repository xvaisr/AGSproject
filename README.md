#AGSproject

Uploadován projekt tak jak je ve wisu, tj. bez jakýchkoliv změn nebo dalších souborů.
Commitujte standardně do master branche. Každý editujte pouze svůj soubor s agenty.
POUZE POKUD !!! byste se z jakýchkoliv důvodů potřebovali vrtat v souborech ostatních,
a POUZE v odůvodnitelných případech si branchněte aktuální verzi ať nedochází ke konfliktu.
Slučování a konflikty se pak budou eventualně řešit individuálně, ale preferoval bych,
aby se žádné konflikty neděli.

Pokud by se někdo chtěl implementovat nějakou interní akci (něco v Javě), byl nejprve rád upozorněn.

----------------------------------------- koding standard

Protože jsem zaznamenal ve zdrojácích agentů nečitelnou šílenost, všechny zdrojáky budou psány
následující notací, aby bylo možné se v nich jednoznačně a snadno orientovat.

formát souboru: 

/* beleave base */

beleave(value).
beleave2(value2, value3).

/* initial goals */

!goal1.
!goal2.

/* plans */

@label[anotation]
+!planA :
  condition1 &
  condition2
<--
  bodyOfPlan;
  bodyOfPlan;

  if (cond) {
      something;

      while (cond) {
          something;
          somethingElse;
      }

      somethingElse;
  }

  bodyOfPlan.
// end planA


+!planB : 
  // krátký komentář k plánu planB, pokud není na první pohled jasné co vlastně planB dělá
  condition1 &
  condition2
<--
  bodyOfPlan;
  bodyOfPlan;

  if (cond & cond2) {
      something;
  }

  if (veryLongLongCondition &
      veryLongLongCondition2)
  {
      something;
  }

  bodyOfPlan.
// end planB


+!planC
  true
<--
  bodyOfPlan;
  bodyOfPlan;
  bodyOfPlan.


+event :
  condition1 &
  condition2
<--
  bodyOfPlan;
  bodyOfPlan;
  bodyOfPlan.


+event : 
  true
<--
  bodyOfPlan;
  bodyOfPlan;
  bodyOfPlan.

/*EOF*/

Pro plány planA a planB platí že mají dlouhé tělo nebo mají v sobě podmínky a cykly, kolem nichž se vynechává
prázdný řádek. Aby bylo na první pohled patrné kde končí, bude za jejich koncem následovat komentář, že tam skutečně
končí (viz. vzor výše). Mezi jednotlivími plány se budou vynechávat dva řádky.

----------------------------------------- update : 20/4/16

Prosím o to abyste commitovali všechny změny tak jak průběžně pracujete. Když nejsou commity a nevidím
jak na tom jednotlivě jste, není možné vás koordinovat nebo se podílet na vívoji tím, že budu procházet
ve volných chvílích vámi vytvořené zdrojáky a hledat potenciální problémy, nebo přímo ty zdrojáky testovat.

Vzhledem k velmi blbé podmínce zadání, kde musí u každého zdroje stát minimálně 2 agenti,
aby bylo vůbec možné zdroj zvednout, během individuální práce na schopnostech samotných agentů
(tj. než se začne řešit komunikační protokol) si v souboru ./mining/WorldModel.java na řádcích
ve funkcích, které jsou na řádku 602 a 674, odeberte víše zmíněnou podmínku aby agenti mohli
fungovat samostatně a jednotlivě. Ve finální verzi ovšem bude podmínka aktivní, takže s tím
počítejte a přemýšlejte jak byste to řešili co se týče komunikačního protokolu mezi agenty.
Komunikační protokol bude další krok až vám budou agenti fungovat samostatně.















