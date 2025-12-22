program LabWork3;
uses crt;

var
  ch: char;
  a, b, res, exact: real;
  n, hub: integer;
  Calculated: boolean;

{ Функция из задания: 1*x^3 + (-2)*x^2 + 0*x + 4 }
function f(x: real): real;
begin
  f := 1*x*x*x + (-2)*x*x + 0*x + 4;
end;

{ Первообразная: (1/4)x^4 - (2/3)x^3 + 4x }
function Fx(x: real): real;
begin
  Fx := 0.25*x*x*x*x - (2/3)*x*x*x + 4*x;
end;

{ Метод ЛЕВЫХ прямоугольников }
function LeftRectangles(a, b: real; n: integer): real;
var
  h, sum, x: real;
  i: integer;
begin
  h := (b - a) / n;
  sum := 0;
  for i := 0 to n-1 do  { Левые прямоугольники: от 0 до n-1 }
  begin
    x := a + i * h;
    sum := sum + f(x);
  end;
  LeftRectangles := sum * h;
end;

{ Процедура вычисления площади }
procedure CalculateArea;
var
  absoluteError, relativeError: real;
begin
  clrscr;
  
  { Базовая проверка }
  if b <= a then
  begin
    writeln('ОШИБКА: b должно быть больше a!');
    writeln('a = ', a:0:4, ', b = ', b:0:4);
    readln;
    exit;
  end;
  
  { Проверка n }
  if n <= 0 then
  begin
    writeln('ОШИБКА: n должно быть больше 0!');
    readln;
    exit;
  end;
  
  { Вычисление }
  writeln('ВЫЧИСЛЕНИЕ ПЛОЩАДИ:');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('Интервал: [', a:0:4, ', ', b:0:4, ']');
  writeln('Метод: левые прямоугольники, n = ', n);
  writeln('----------------------------------------');
  
  res := LeftRectangles(a, b, n);
  exact := Fx(b) - Fx(a);
  Calculated := true;
  
  { Вывод результатов }
  writeln('РЕЗУЛЬТАТЫ:');
  writeln('  Численный метод:          ', res:0:8);
  writeln('  Метод Ньютона-Лейбница:   ', exact:0:8);
  writeln('  ---------------------------------');
  
  { Вычисление погрешностей }
  absoluteError := abs(exact - res);
  writeln('  Абсолютная погрешность:   ', absoluteError:0:8);
  
  if exact <> 0 then
  begin
    relativeError := (absoluteError / exact) * 100;
    writeln('  Относительная погрешность: ', relativeError:0:6, '%');
  end;
  
  readln;
end;

{ Процедура оценки погрешности }
procedure EstimateError;
var
  absoluteError, relativeError: real;
begin
  clrscr;
  
  if not Calculated then
  begin
    writeln('Сначала выполните вычисление площади!');
    readln;
    exit;
  end;
  
  writeln('ОЦЕНКА ПОГРЕШНОСТИ:');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('Интервал: [', a:0:4, ', ', b:0:4, ']');
  writeln('Метод: левые прямоугольники, n = ', n);
  writeln('----------------------------------------');
  
  { Прямое сравнение с точным значением }
  writeln('ПРЯМОЕ СРАВНЕНИЕ С ТОЧНЫМ ЗНАЧЕНИЕМ:');
  writeln('  Метод левых прямоугольников: ', res:0:10);
  writeln('  Метод Ньютона-Лейбница:      ', exact:0:10);
  
  absoluteError := abs(exact - res);
  writeln('  Абсолютная погрешность:      ', absoluteError:0:10);
  
  if exact <> 0 then
  begin
    relativeError := (absoluteError / exact) * 100;
    writeln('  Относительная погрешность:    ', relativeError:0:4, '%');
  end;
  
  readln;
end;

{ Процедура выхода из программы }
procedure ExitProgram;
begin
  clrscr;
  writeln('Завершение программы...');
  halt;
end;

{ Отображение меню }
procedure DisplayMenu;
begin
  clrscr;
  writeln('Лабораторная работа N3');
  writeln('Изучение базовых принципов организации процедур и функций');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('----------------------------------------');
  
  { Меню с указателем выбора }
  if hub = 1 then write('-> ') else write('   ');
  writeln('1. Ввести нижний предел (a)');
  
  if hub = 2 then write('-> ') else write('   ');
  writeln('2. Ввести верхний предел (b)');
  
  if hub = 3 then write('-> ') else write('   ');
  writeln('3. Ввести количество разбиений (n)');
  
  if hub = 4 then write('-> ') else write('   ');
  writeln('4. Вычислить площадь');
  
  if hub = 5 then write('-> ') else write('   ');
  writeln('5. Оценить погрешность');
  
  if hub = 6 then write('-> ') else write('   ');
  writeln('6. Выход');
  
  writeln('----------------------------------------');
  writeln('Текущие параметры:');
  writeln('  a = ', a:0:4, '    b = ', b:0:4, '    n = ', n);
  writeln('----------------------------------------');
  writeln('Управление: стрелки вверх/вниз, Enter');
end;

{ Основная программа }
begin
  { Инициализация переменных нулевыми значениями }
  a := 0.0;
  b := 0.0;
  n := 0;
  hub := 1;
  Calculated := false;
  
  while true do
  begin
    DisplayMenu;
    ch := ReadKey;
    
    if ch = #0 then
      ch := ReadKey;
    
    case ch of
      #38: { Вверх }
        if hub > 1 then hub := hub - 1 else hub := 6;
      
      #40: { Вниз }
        if hub < 6 then hub := hub + 1 else hub := 1;
      
      #13: { Enter }
        case hub of
          1: { Ввод a }
          begin
            clrscr;
            writeln('ВВОД НИЖНЕГО ПРЕДЕЛА (a):');
            writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
            writeln;
            write('Введите a: ');
            readln(a);
            Calculated := false;
          end;
          
          2: { Ввод b }
          begin
            clrscr;
            writeln('ВВОД ВЕРХНЕГО ПРЕДЕЛА (b):');
            writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
            writeln;
            write('Введите b: ');
            readln(b);
            Calculated := false;
          end;
          
          3: { Ввод n }
          begin
            clrscr;
            writeln('ВВОД КОЛИЧЕСТВА РАЗБИЕНИЙ (n):');
            writeln('Метод: левые прямоугольники');
            writeln('Чем больше n, тем точнее результат');
            writeln;
            write('Введите n (рекомендуется ≥ 100): ');
            readln(n);
            Calculated := false;
          end;
          
          4: CalculateArea;    { Вычисление площади }
          
          5: EstimateError;    { Оценка погрешности }
          
          6: ExitProgram;      { Выход }
        end;
    end;
  end;
end.
