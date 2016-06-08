// Reverse polish notation
// Обратная польская запись
// Версия взята из интернета
// адрес: https://ru.wikiversity.org/wiki/%D0%9E%D0%B1%D1%80%D0%B0%D1%82%D0%BD%D0%B0%D1%8F_%D0%BF%D0%BE%D0%BB%D1%8C%D1%81%D0%BA%D0%B0%D1%8F_%D0%B7%D0%B0%D0%BF%D0%B8%D1%81%D1%8C:_%D0%BF%D1%80%D0%B8%D0%BC%D0%B5%D1%80%D1%8B_%D1%80%D0%B5%D0%B0%D0%BB%D0%B8%D0%B7%D0%B0%D1%86%D0%B8%D0%B8#Delphi
// Анализирует выражение и считает его
// Это для Gita
// Это опять туда же

program calc;

const
  prs = '+-*/(';
  pri: array [1 .. 5] of byte = (1, 1, 2, 2, 0);

var
  s1, s2: String;
  q: array [0 .. 500] of Real;
  w: array [0 .. 500] of Char;
  n, len, len2: Cardinal;
  t: Real;
  ch: Char;

procedure Push(x: Real);
begin
  Inc(len);
  q[len] := x;
end;

function Pop: Real;
begin
  Pop := q[len];
  q[len] := 0;
  Dec(len);
end;

procedure PushC(x: Char);
begin
  Inc(len2);
  w[len2] := x;
end;

function Popc: Char;
begin
  Popc := w[len2];
  w[len2] := #0;
  Dec(len2);
end;

function Oper(s1, s2: Real; s3: Char): Real;
var
  x, y, z: Real;
begin
  x := s1;
  y := s2;
  case s3 of
    '+': z := x + y;
    '-': z := x - y;
    '*': z := x * y;
    '/': z := x / y;
  end;
  Oper := z;
end;

procedure PreChange(var s: String);
var
  i: Cardinal;
begin
  if s[1] = '-' then
    s := '0' + s;
  i := 1;
  while i <= n do
    if (s[i] = '(') and (s[i + 1] = '-') then
      insert('0', s, i + 1)
    else
      Inc(i);
end;

function Change(s: String): String;
var
  i: Cardinal;
  rezs: String;
  c: Boolean;
begin
  rezs:='';
  c := false;
  for i := 1 to n do
    begin
      if not(s[i] in ['+', '-', '*', '/', '(', ')']) then
        begin
          if c then
            rezs := rezs + ' ';
          rezs := rezs + s[i];
          c := false;
        end
      else
        begin
          c := true;
          if s[i] = '(' then
            PushC(s[i])
          else
            if s[i] = ')' then
              begin
                while w[len2] <> '(' do
                  begin
                    rezs := rezs + ' ' + Popc;
                  end;
                Popc;
              end
            else
              if s[i] in ['+', '-', '*', '/'] then
                begin
                  while pri[Pos(w[len2], prs)] >= pri[Pos(s[i], prs)] do
                    rezs := rezs + ' ' + Popc;
                  PushC(s[i]);
                end;
        end;
    end;
  while len2 <> 0 do
    rezs := rezs + ' ' + Popc;
  Change := rezs;
end;

function Count(s: String): Real;
var
  ss: String;
  x, s1, s2: Real;
  chh, s3: Char;
  p, i, j: Cardinal;
  tmp: Integer;
begin
  i := 0;
  repeat
    j := i + 1;
    repeat
      Inc(i)
    until s[i] = ' ';
    ss := copy(s, j, i - j);
    chh := ss[1];
    if not(chh in ['+', '-', '*', '/']) then
      begin
        Val(ss, p, tmp);
        Push(p);
      end
    else
      begin
        s2 := Pop;
        s1 := Pop;
        s3 := chh;
        Push(Oper(s1, s2, s3));
      end;
  until i >= n;
  x := Pop;
  Count := x;
end;

procedure WriteL(x: Real);
var
  y, a, b: Cardinal;
  q: Real;
begin
  y := Trunc(x);
  b := 0;
  if Abs(x - y) < (1E-12) then
    Writeln(y)
  else
    begin
      if y > 0 then
        a := round(ln(y) / ln(10)) + 1
      else
        a := 1;
      q := x;
      repeat
        q := q * 10;
        Inc(b);
      until Abs(q - Trunc(q)) < (1E-12);
      Writeln(x:a + b:b);
    end;
end;

begin
  repeat
    Writeln('Enter expression');
    Readln(s1);
    n := Length(s1);
    PreChange(s1);
    n := Length(s1);
    s2 := Change(s1);
    if s2[1] = ' ' then
      delete(s2, 1, 1);
    s2 := s2 + ' ';
    n := Length(s2);
    t := Count(s2);
    WriteL(t);
    Writeln('One more expression?(Y/N)');
    Readln(ch);
  until UpCase(ch) = 'N';

end.
