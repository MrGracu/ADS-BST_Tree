program ADS_BST_Tree;

uses crt;

type
  wsk = ^element;
  element = record
    dana:integer;
    przodek,lewe,prawe:wsk;
  end;

procedure wyczyscAll(korzen:wsk);
begin
  if(korzen^.lewe <> nil) then wyczyscAll(korzen^.lewe);
  if(korzen^.prawe <> nil) then wyczyscAll(korzen^.prawe);
  dispose(korzen);
end;

procedure dodajElement(var korzen:wsk);
var
  nowy,liczba:wsk;
  czyUmieszczono:boolean;
begin
  ClrScr;
  new(nowy);
  if(nowy = nil) then
  begin
    writeln('Nie udalo sie zaalokowac pamieci!');
    writeln('Aby wrocic do menu nacisnij ENTER...');
    readln();
    exit;
  end;
  writeln('Podaj wartosc');
  readln(nowy^.dana);
  nowy^.lewe:=nil;
  nowy^.prawe:=nil;
  nowy^.przodek:=nil;
  if(korzen = nil) then
  begin
    korzen:=nowy;
    exit;
  end;
  liczba:=korzen;
  czyUmieszczono:=false;
  while (not czyUmieszczono) do
  begin
    if(liczba^.dana = nowy^.dana) then
    begin
      writeln('Podana liczba juz istnieje!');
      writeln('Aby wrocic do menu nacisnij ENTER...');
      dispose(nowy);
      readln();
      exit;
    end;
    if(nowy^.dana < liczba^.dana) then
    begin
      if(liczba^.lewe <> nil) then
      begin
        liczba:=liczba^.lewe;
      end else
      begin
        nowy^.przodek:=liczba;
        liczba^.lewe:=nowy;
        czyUmieszczono:=true;
      end;
    end else
    begin
      if(liczba^.prawe <> nil) then
      begin
        liczba:=liczba^.prawe;
      end else
      begin
        nowy^.przodek:=liczba;
        liczba^.prawe:=nowy;
        czyUmieszczono:=true;
      end;
    end;
  end;
end;

procedure inorder(wezel:wsk);
begin
  if(wezel^.lewe <> nil) then inorder(wezel^.lewe);
  write(wezel^.dana,' ');
  if(wezel^.prawe <> nil) then inorder(wezel^.prawe);
end;

procedure postorder(wezel:wsk);
begin
  if(wezel^.lewe <> nil) then postorder(wezel^.lewe);
  if(wezel^.prawe <> nil) then postorder(wezel^.prawe);
  write(wezel^.dana,' ');
end;

procedure preorder(wezel:wsk);
begin
  write(wezel^.dana,' ');
  if(wezel^.lewe <> nil) then preorder(wezel^.lewe);
  if(wezel^.prawe <> nil) then preorder(wezel^.prawe);
end;

procedure wyswietl(korzen:wsk);
var
  n:integer;
begin
  if(korzen = nil) then
  begin
    ClrScr;
    writeln('Brak elementow do wyswietlenia!');
    writeln('Aby wrocic do menu nacisnij ENTER...');
    readln();
    exit;
  end;
  repeat
    ClrScr;
    writeln('Wyswietl za pomoca metody:');
    writeln('1) inorder');
    writeln('2) postorder');
    writeln('3) preorder');
    readln(n);
  until ((n < 4) and (n > 0));
  ClrScr;
  case n of
  1: inorder(korzen);
  2: postorder(korzen);
  3: preorder(korzen);
  end;
  writeln();
  writeln('Aby wrocic do menu nacisnij ENTER...');
  readln();
end;

function znajdzAdres(korzen:wsk;n:integer):wsk;
begin
  if(korzen^.dana = n) then znajdzAdres:=korzen else
  begin
    if((n < korzen^.dana) and (korzen^.lewe <> nil)) then znajdzAdres:=znajdzAdres(korzen^.lewe,n) else
    begin
      if((n > korzen^.dana) and (korzen^.prawe <> nil)) then znajdzAdres:=znajdzAdres(korzen^.prawe,n) else znajdzAdres:=nil;
    end;
  end;
end;

function znajdzMin(wezel:wsk):wsk;
begin
  if(wezel^.lewe <> nil) then znajdzMin:=znajdzMin(wezel^.lewe) else znajdzMin:=wezel;
end;

procedure usunElement(var korzen:wsk);
var
  n:integer;
  element,liczba:wsk;
begin
  ClrScr;
  if(korzen = nil) then
  begin
    writeln('Brak elementow do wyswietlenia!');
    writeln('Aby wrocic do menu nacisnij ENTER...');
    readln();
    exit;
  end;
  writeln('Wpisz wartosc elementu do usuniecia:');
  readln(n);
  element:=znajdzAdres(korzen,n);
  if(element = nil) then
  begin
    writeln('Nie znaleziono szukanego elementu!');
    writeln('Aby wrocic do menu nacisnij ENTER...');
    readln();
    exit;
  end;

  if((element^.lewe = nil) or (element^.prawe = nil)) then
  begin
    if(element^.przodek = nil) then
    begin
      if(element^.lewe <> nil) then korzen:=element^.lewe else
      if(element^.prawe <> nil) then korzen:=element^.prawe else korzen:=nil;
      dispose(element);
    end else
    begin
      if(element^.prawe <> nil) then
      begin
        liczba:=znajdzMin(element^.prawe);
        if(liczba^.prawe = nil) then
        begin
          element^.prawe:=nil;
        end else
        begin
          liczba^.prawe^.przodek:=liczba^.przodek;
          if(liczba^.przodek^.prawe = liczba) then liczba^.przodek^.prawe:=liczba^.prawe else liczba^.przodek^.lewe:=liczba^.prawe;
        end;
        element^.dana:=liczba^.dana;
        dispose(liczba);
      end else
      begin
        if(element^.lewe <> nil) then
        begin
          element^.lewe^.przodek:=element^.przodek;
        end;
        if(element^.przodek^.prawe = element) then element^.przodek^.prawe:=element^.lewe else element^.przodek^.lewe:=element^.lewe;
        dispose(element);
      end;
    end;
  end else
  begin
    liczba:=znajdzMin(element^.prawe);
    if(liczba^.prawe = nil) then
    begin
      if(liczba^.przodek^.prawe = liczba) then liczba^.przodek^.prawe:=nil else liczba^.przodek^.lewe:=nil;
    end else
    begin
      liczba^.prawe^.przodek:=liczba^.przodek;
      if(liczba^.przodek^.prawe = liczba) then liczba^.przodek^.prawe:=liczba^.prawe else liczba^.przodek^.lewe:=liczba^.prawe;
    end;
    element^.dana:=liczba^.dana;
    dispose(liczba);
  end;
  writeln('Usunieto!');
  writeln('Aby wrocic do menu nacisnij ENTER...');
  readln();
end;

var
  n:integer;
  korzen:wsk;
begin
  korzen:=nil;
  repeat
    ClrScr;
    writeln('1) Dodaj element do drzewa BST');
    writeln('2) Wyswietl drzewo BST');
    writeln('3) Usun element z drzewa BST');
    writeln('0) Wyjscie');
    readln(n);
    case n of
    1: dodajElement(korzen);
    2: wyswietl(korzen);
    3: usunElement(korzen);
    end;
  until (n=0);
  if(korzen <> nil) then
  begin
    wyczyscAll(korzen);
    korzen:=nil;
  end;
end.

