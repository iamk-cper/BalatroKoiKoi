# Dokumentacja projektu zaliczeniowego Balatro Koi-Koi

## Opis projektu

* **Nazwa i inspiracja:** Gra karciana single player inspirowana mechanikami gier Balatro (karcianka roguelike z elementami pokera) oraz Koi-Koi (tradycyjna japońska gra karciana Hanafuda). Projekt łączy elementy obu - strategiczne tworzenie kombinacji kart (jak w Koi-Koi) oraz progresję roguelike (jak w Balatro).
* **Cel projektu:** Stworzenie wciągającej gry dla jednego gracza, w której gracz kolekcjonuje punkty poprzez zbieranie kombinacji kart i podejmuje decyzje ryzyka (kontynuować rundę czy zakończyć, analogicznie do mechaniki „Koi-Koi"). Gra ma oferować satysfakcjonującą progresję i możliwość ulepszania talii lub zdolności między rundami.
* **Autor:** Kacper Myćka - odpowiedzialny za planowanie, projektowanie mechaniki i interfejsu, implementację kodu, testowanie oraz przygotowanie dokumentacji. Projekt realizowany jednoosobowo, wszystkie role (developer, designer, tester) pełni autor.
* **Repozytorium:** Kod źródłowy gry jest dostępny w repozytorium GitHub: BalatroKoiKoi (link: https://github.com/iamk-cper/BalatroKoiKoi). Repozytorium zawiera aktualną wersję gry (0.1.0) wraz z historią zmian i planowanymi usprawnieniami.
* **Status projektu:** Wersja alfa 0.1.0 (grywalna podstawowa wersja). Dokumentacja opisuje stan na wersję 0.1.0 oraz przewiduje dalszy rozwój funkcjonalności.

![image](https://github.com/user-attachments/assets/84c66bf5-b5da-4069-ad89-4f9a22655100)

## Zasady gry

* **Cel gry:** Zdobywanie punktów poprzez tworzenie wartościowych kombinacji kart. Gra kończy się wygraną po pomyślnym ukończeniu finałowej rundy (osiągnięciu wszystkich zaplanowanych etapów) lub przegraną, jeśli gracz nie zdoła ukończyć rund (np. straci wszystkie szanse/życia lub nie osiągnie wymaganego wyniku).
* **Talia kart:** W grze wykorzystano karty inspirowane talią Hanafuda (12 miesięcy, każdy reprezentowany przez unikalne karty) oraz elementy z Balatro (np. karty specjalne/jokery wpływające na rozgrywkę). Łącznie talia składa się z określonej liczby kart podzielonych na grupy odpowiadające miesiącom/pora roku, z dodatkowymi kartami specjalnymi zwiększającymi różnorodność rozgrywki. Nie zastosowano klasycznych kolorów i figur jak w pokerze - zamiast tego kombinacje bazują na tradycyjnych układach Hanafuda (tzw. Yaku) uzupełnionych o efekty specjalne kart Balatro.
* **Przebieg rozgrywki:** Gra toczy się w turach podzielonych na rundy:
    * Na początku rundy gracz otrzymuje początkową rękę kart, a na stole wykładany jest układ startowy (kilka odkrytych kart, z którymi można tworzyć pary).
    * **Tura gracza:** Gracz zagrywa jedną kartę z ręki na stół. Jeśli zagrana karta tworzy parę z pasującą kartą leżącą na stole (np. odpowiadają ten sam miesiąc/rodzaj), gracz zbiera tę parę kart i odkłada je do swojego stosu punktów.
    * Po zagraniu karty gracz dobiera następną kartę z talii dobierania i sprawdza, czy może utworzyć parę z kartą na stole. Jeśli tak, również zbiera parę do swojego stosu.
    * Jeśli dobrana karta nie ma pary na stole, pozostaje ona na stole jako kolejna karta dostępna do par w następnych ruchach.
    * Gracz może również wymienić do 4 kart z ręki na 4 karty z talii.
* **Kombinacje i punktacja:** Celem jest tworzenie Yaku - specjalnych kombinacji zebranych kart, które dają punkty:
    * Przykładowe Yaku (kombinacje) inspirowane Hanafudą to m.in. zbiór określonych roślin lub zwierząt z kart miesięcy, zestaw różnych typów kart (światło, zwierzęta, wstążki) itp. Każda kompletna kombinacja dodaje ustaloną liczbę punktów do wyniku gracza.
    * **Balans punktów:** Zasady punktacji zostały zbalansowane - prostsze kombinacje dają mniej punktów, zaś trudniejsze (rzadsze) układy premiowane są wyższą punktacją. Wprowadzono ograniczenia, aby żadna pojedyncza kombinacja czy karta specjalna (np. joker z Balatro) nie zdominowała rozgrywki. Dzięki temu gracz musi łączyć różne układy, by osiągnąć wysokie wyniki, zamiast polegać na jednej strategii.

## TBD:
* **Zakończenie rundy (mechanika Koi-Koi):** Po zdobyciu co najmniej jednej kombinacji Yaku w rundzie, gracz ma decyzję:
    * **Zakończyć rundę** - wtedy podliczane są punkty za wszystkie zebrane kombinacje, punkty te dodają się do ogólnego wyniku, a runda kończy się. Przejście do kolejnej rundy następuje bez ryzyka utraty punktów.
    * **„Koi-Koi" (kontynuować)** - gracz ryzykuje i kontynuuje rundę, aby spróbować zdobyć więcej kombinacji w kolejnych turach tej samej rundy. Jeżeli jednak w dalszej części rundy nie uda mu się zdobyć dodatkowych kombinacji zanim talia się wyczerpie lub nastąpi zakończenie rundy z innego powodu, traci wcześniej zdobyte punkty z tej rundy. Mechanika ta zmusza gracza do oceny ryzyka: czy zachować zdobyte punkty, czy grać dalej by zwiększyć wygraną kosztem ryzyka jej utraty.
* **Progresja rozgrywki:** Gra składa się z serii następujących po sobie rund/etapów. Z każdą kolejną rundą poziom trudności wzrasta:
    * W późniejszych rundach mogą pojawić się dodatkowe reguły utrudniające (np. ograniczona liczba tur na rundę, wyższy próg punktowy do osiągnięcia, dodatkowe karty negatywne utrudniające zdobywanie punktów).
    * Punkty zdobyte w poprzednich rundach przenoszą się i stanowią podstawę wyniku całkowitego. Część z nich może służyć jako waluta w sklepie pomiędzy rundami (patrz sekcja Sklep).
    * Gracz wygrywa całą grę, jeśli przejdzie wszystkie rundy od początku do końca, utrzymując się powyżej zera punktów (lub mając przynajmniej jedną wygraną rundę) i spełniając warunki zwycięstwa finałowej rundy. Przegrana następuje, jeśli na dowolnym etapie gracz nie zdobył minimalnej wymaganej liczby punktów lub spełnił warunki porażki (np. brak punktów, wyczerpanie możliwości ruchu).
* **Sklep (ulepszenia między rundami):** Po zakończeniu każdej rundy (o ile gra nie została zakończona) gracz otrzymuje możliwość skorzystania ze sklepu:
    * W sklepie gracz może wydawać zdobyte punkty (lub specjalną walutę otrzymywaną za wygrane rundy) na ulepszenia. Ulepszenia mogą obejmować: dodanie specjalnych kart do talii, jednorazowe bonusy (np. podgląd następnej karty, dodatkowe dobieranie) lub zwiększenie przyszłych zdobyczy punktowych.
    * Dostępne ulepszenia zostały zbalansowane tak, by żadna pojedyncza opcja nie gwarantowała łatwego zwycięstwa - gracz musi wybierać strategicznie. Przykładowo, zakup karty Joker (działającej jak karta dowolna pasująca do każdej pary) jest drogi i limitowany do 1, aby nie zniweczyć losowości i wyzwania gry.
    * Ulepszenia zakupione w sklepie zaczynają obowiązywać od następnej rundy. Sklep stanowi kluczowy element roguelike'owej progresji - między starciami (rundami) gracz ulepsza swoje „szanse" na sukces w kolejnych etapach.
* **Balans rozgrywki:** Zasady gry zostały iteracyjnie dostrojone pod kątem balansu:
    * Zapewniono, że rozgrywka jest sprawiedliwa, a losowość kart jest zrównoważona poprzez mechanizmy kompensacyjne (np. gwarantowane minimum jednego możliwego ruchu na turę, aby uniknąć sytuacji całkowitego pecha).
    * Poziom trudności rośnie stopniowo - pierwsze rundy wprowadzają gracza w mechanikę (łatwiejsze kombinacje, mniej wymagań punktowych), a kolejne stanowią coraz większe wyzwanie. Dzięki temu krzywa uczenia się jest łagodna, a jednocześnie gra pozostaje angażująca na dalszych etapach.
    * Wprowadzono ograniczenia liczby niektórych silnych kart (np. wspomnianych jokerów czy innych kart specjalnych) w talii oraz limity ich użycia w rundzie, aby utrzymać wyzwanie. Każda strategia ma swoje wady i zalety - gracze muszą adaptować się do warunków rozdania i dostępnych ulepszeń.


## Wersja 0.1.0 i plany rozwoju

* **Wersja 0.1.0 (aktualna):** Pierwsza publiczna wersja alfa gry zawierająca pełny podstawowy zestaw funkcjonalności:
    * Implementowane są wszystkie główne mechaniki rozgrywki: rozgrywanie rund zgodnie z zasadami Koi-Koi, podstawowe kombinacje (Yaku) i system punktacji.
    * Interfejs użytkownika jest w stanie podstawowym - wyświetla karty, punkty, komunikaty o zdobytych kombinacjach, opcje zakończenia rundy i przejścia do sklepu.
    * Brak zaawansowanych funkcji: brak pełnego samouczka, brak dźwięków, prosta oprawa graficzna.
* **Stabilność:** Wersja 0.1.0 została przetestowana pod kątem krytycznych błędów - gra nie zawiesza się, mechaniki działają zgodnie z opisem.
* **Planowane ulepszenia (roadmap):** Kolejne wersje gry będą rozwijać zawartość i ulepszać jakość:
    * **Wersja 0.2.0:** Rozszerzenie zawartości - wprowadzenie systemu kampanii, decyzja Koi-Koi (kontynuacja/zakonczenie rundy), system sklepu między rundami oraz prosta progresja poziomów trudności, karty specjalne, ulepszenie oprawy graficznej, efekty animacji przy zbieraniu par, dodanie podstawowych efektów dźwiękowych dla lepszej immersji.
    * **Wersja 0.3.0:** Poprawa interfejsu i doświadczenia gracza - wprowadzenie samouczka interaktywnego objaśniającego zasady krok po kroku, dodanie czytelniejszych komunikatów i wskaźników możliwych ruchów; wprowadzenie mechanizmu zapisu postępów gry (np. możliwość przerwania i wznowienia kampanii).
    * **Wersja 1.0.0 (planowana pełna wersja):** Finalizacja gry - pełne zbalansowanie wszystkich poziomów i kart na podstawie feedbacku testerów, dodanie trybu wyzwań lub endless (nieskończonej rozgrywki dla zaawansowanych graczy), implementacja tabeli wyników lokalnych (high score).
* **Dalszy rozwój:** Po wersji 1.0 planowane są aktualizacje typu live-ops: nowe zestawy kart (np. dodatkowe motywy Hanafuda), wydarzenia okresowe (np. specjalne wyzwania tygodniowe) oraz porty gry na inne platformy (PC, być może urządzenia mobilne) - w zależności od zapotrzebowania. Wszystkie przyszłe zmiany będą dokumentowane w repozytorium i dołączanej dokumentacji.

## Technologie

* **Silnik gry:** Godot Engine - gra została stworzona przy użyciu silnika Godot (wersja 4.4.1) zapewniającego wydajne zarządzanie scenami 2D oraz łatwe tworzenie interfejsu użytkownika.
* **Język skryptowy:** GDScript - logika gry (zasady, zachowanie kart, obsługa interfejsu) została zaimplementowana w języku GDScript, natywnym dla Godota. Skrypty GDScript są przypisane do odpowiednich Node'ów (węzłów) w drzewie scen, co ułatwia organizację kodu zgodnie ze strukturą gry.
* **Struktura Node:** Projekt korzysta z węzłów (Node) Godota do podziału funkcjonalności:
    * Główna scena gry zawiera węzły odpowiedzialne za kluczowe elementy: np. Game (węzeł nadrzędny zarządzający stanem gry), CardManager (logika kart i rozgrywki), GUI (interfejs graficzny użytkownika) oraz inne węzły dla tła stołu, efektów wizualnych itp.
    * Dzięki modularnej strukturze Node łatwo można rozszerzać grę - np. dodając nowy węzeł Shop dla obsługi sklepu.
* **Grafika i shadery:** Do tworzenia efektów graficznych wykorzystano GDShader (Godot Shader Language).
* **Baza danych:** Brak zewnętrznej bazy danych. Gra nie wymaga zapisywania danych na serwerze - wszystkie dane rozgrywki są przechowywane w pamięci w trakcie gry. Ewentualny zapis postępu (w przyszłych wersjach) wykorzysta mechanizmy plików lokalnych (np. zapis do pliku JSON).
* **Platforma docelowa:** Gra działa jako aplikacja desktopowa (Windows/Linux) uruchamiana lokalnie. Godot umożliwia eksport na różne platformy, co planowane jest w późniejszych etapach (np. WebGL do uruchomienia w przeglądarce lub APK na Androida, w razie zapotrzebowania).

## Etapy realizacji

* **Etap 1: Planowanie projektu (początek maja 2025):** Rozpoczęcie prac koncepcyjnych nad grą. Określenie głównych założeń i mechanik - decyzja o połączeniu elementów Balatro i Koi-Koi, spisanie wstępnych zasad gry, zaplanowanie funkcjonalności (listy wymagań). Przygotowanie prostych prototypów.
* **Etap 2: Projektowanie i prototypowanie (I połowa maja 2025):** Utworzenie projektu w silniku Godot. Zaimplementowanie podstawowej struktury scen (Node) - stworzenie sceny głównej gry, węzłów dla stołu, kart, GUI.
* **Etap 3: Implementacja głównych mechanik (II połowa maja 2025):** Rozbudowanie prototypu o pełne zasady gry:
    * Dodanie wszystkich typów kart i podstawowych kombinacji (Yaku).
    * Wprowadzenie systemu punktacji.
* **Etap 4: Testy (początek czerwca 2025):** Intensywne testowanie wewnętrzne całej gry.
* **Etap 5: Finalizacja wersji 0.1.0 (7-8 czerwca 2025):** Ostatnie szlify przed wydaniem:
    * Przygotowanie pakietu gry do dystrybucji (eksport projektu Godot do binariów).
    * Sporządzenie dokumentacji projektowej oraz instrukcji dla użytkownika w grze (skrót zasad w menu pomocy).

## Interfejs użytkownika i rozgrywka

* **Elementy interfejsu:** Główny ekran gry prezentuje stół do gry i karty:
    * Na środku ekranu znajduje się obszar stołu, gdzie wykładane są karty ze stołu (karty dostępne do zbierania) oraz gdzie gracz zagrywa swoje karty z ręki.
    * **Ręka gracza** (posiadane karty) wyświetlana jest na dole ekranu - karty te są widoczne dla gracza i może on wybierać, którą zagrać.
    * Po prawej widzimy podzielone na typy zebrane karty przez gracza.
    * Po lewej znajdują się niedostępne jeszcze funkcjonalności.
    * Przestrzeń na górze ekranu będzie zawierać w przyszłości talizmany, system znany z gry Balatro
* **Sterowanie:** Gra obsługiwana jest myszą i prostym interaktywnym wskazywaniem:
    * Gracz wybiera kartę z ręki klikając na nią (lub dotyka, w przypadku ekranu dotykowego) i następnie klika kartę na stole, z którą chce ją połączyć. Jeśli wybrano pasujące karty, gracz zatwierdza wybór.
* **Responsywność i czytelność:** UI zostało zaprojektowane tak, aby było czytelne nawet na mniejszych ekranach - duże grafiki kart, wyraźne fonty dla punktów. Rozmieszczenie elementów zostało zoptymalizowane: stół na środku, ręka na dole, informacje i przyciski po bokach lub u góry. Kolorystyka interfejsu jest stonowana z wyraźnymi akcentami dla elementów interaktywnych.
* **Stan gry i przejścia:** Po zakończeniu całej gry (wygranej lub przegranej) interfejs wyświetla ekran podsumowania z wynikiem oraz opcją rozpoczęcia nowej gry. W przypadku przerwania rozgrywki (zamknięcia aplikacji) obecna wersja nie przewiduje zapisu - gra zaczyna się od nowa. (Planowane jest dodanie zapisu stanu gry w przyszłych wersjach, patrz plany rozwoju.)

## Przypadki użycia

* **UC-1: Rozpoczęcie nowej gry** - Gracz uruchamia grę i z poziomu menu głównego wybiera opcję „Nowa gra". System inicjalizuje nową rozgrywkę: tasuje talię kart, ustawia początkowy stan rundy (rozdaje karty graczowi i wykłada startowe karty na stół) oraz wyświetla interfejs gry (stół, ręka gracza). Przypadek użycia kończy się, gdy gracz widzi pierwszą rundę gotową do gry.
* **UC-2: Rozgrywanie rundy i zdobywanie punktów** - Gracz uczestniczy w rundzie rozgrywki:
    * **Podstawowy przebieg:** Gracz zagrywa kartę z ręki na stół, zbiera pary kart zgodnie z zasadami (jeśli to możliwe), dobiera kartę z talii i również sprawdza możliwe pary. Tura gracza może się powtarzać tak długo, jak są karty do zagrania lub do dobrania.
    * Przypadek użycia kończy się wraz z zakończeniem rundy, gra wyświetla podsumowanie, a gracz opuszcza grę.
* **UC-3: Ponowna rozgrywka** - Gracz po zakończonej rozgrywce rozpoczyna kolejną.
* **UC-4: Sprawdzenie zasad** - Gracz uruchamia grę i z poziomu menu wchodzi w zasady. Następnie wychodzi z zasad i opuszcza aplikację lub rozpoczyna rozgrywkę.

### Diagram przypadków użycia
![image](https://github.com/user-attachments/assets/f7cd6b6c-2fa1-49da-81fa-725dd6694325)


## Architektura

* **Struktura gry:** Architektura opiera się na silniku Godot i wykorzystuje sceny oraz węzły (Node) do podziału funkcjonalności:
    * Główna scena Game zawiera kluczowe węzły: m.in. TextureRect (tło stołu do gry), GUI (kontrolki interfejsu użytkownika, np. wyświetlacze punktów, przyciski), CardManager (logika rozgrywki i zarządzanie kartami) oraz inne. Każdy węzeł może posiadać własne dzieci; np. węzeł GUI ma pod-węzły dla paneli, przycisków i tekstów interfejsu.
    * Węzeł CardManager zarządza instancjami kart na stole i w ręce gracza. Karty mogą być reprezentowane jako osobne węzły (np. typu Sprite lub TextureButton z obrazkiem karty), które są dynamicznie dodawane/usuwane jako dzieci odpowiednich kontenerów (np. kontener stołu, kontener ręki).
    * Nie ma wydzielonej warstwy backend (gra działa w pełni lokalnie), stąd architektura jest jednopoziomowa: Godot obsługuje zarówno logikę, jak i prezentację. Komunikacja wewnątrz gry opiera się na sygnałach Godota (np. sygnał wywoływany przy kliknięciu karty uruchamia metodę w CardManager sprawdzającą ruch).
* **Moduły i skrypty:** Każdy główny węzeł posiada przypisany skrypt GDScript realizujący jego zadania, np.
    * Skrypt CardManager.gd - zawiera logikę rozgrywki w trakcie rundy: tasowanie talii, rozdawanie kart, sprawdzanie dopasowań, naliczanie punktów, wykrywanie Yaku, obsługę decyzji Koi-Koi oraz kończenie rundy.

### Architektura aplikacji
![image](https://github.com/user-attachments/assets/fdc3b4f1-c5f0-4cb9-b183-e92eb1f51f96)


### Przykładowy fragment struktury aplikacji
![image](https://github.com/user-attachments/assets/3876224c-b070-466b-a67a-0cb366858ea9)


## Testowanie

* **Testy jednostkowe (modułowe):** Dla krytycznych fragmentów logiki gry przygotowano testy jednostkowe w środowisku Godot:
    * Sprawdzenie poprawności wykrywania kombinacji Yaku - symulacje układów kart wejściowych i weryfikacja, czy gra nalicza właściwą liczbę punktów za dane kombinacje.
* **Testy integracyjne (rozgrywki):** Przeprowadzono pełne testy grając w grę od początku do końca wielokrotnie:
    * Celem było sprawdzenie, czy wszystkie elementy współdziałają poprawnie - od rozdania kart, przez zbieranie punktów i finalne zakończenie gry.
    * Podczas testów integracyjnych wykryto i naprawiono liczne błędy, np. sytuacje braku możliwych ruchów, brak automatycznego kończenia rozgrywki, błędne działanie przycisków. Każdy z tych błędów został odnotowany i usunięty przed wydaniem wersji 0.1.0.
* **Testy interfejsu (UI/UX):** Sprawdzono ręcznie działanie interfejsu użytkownika:
    * Reakcje na kliknięcia kart i przycisków - każda interaktywna opcja (zagranie karty, przycisk zakończenia rundy) została przetestowana pod kątem poprawności działania i braku zacięć.
    * Czytelność komunikatów - oceniono, czy wyświetlane informacje są zrozumiałe.
    * Rozdzielczości ekranu - gra została uruchomiona w różnych rozdzielczościach okna, aby upewnić się, że interfejs skaluje się poprawnie i żaden element nie wychodzi poza ekran ani się nie nakłada.
* **Testy wydajnościowe:** Jako że gra nie jest bardzo zasobożerna, testy wydajności polegały głównie na obserwacji płynności działania.
