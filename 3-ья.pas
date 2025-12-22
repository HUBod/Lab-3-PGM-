program Lab3;
uses crt;

var
  ch: char;
  a, b, res, exact: real;
  n, sel: integer;
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

{ Метод ЛЕВЫХ прямоугольников (как требует задание) }
function LeftRectangles(a, b: real; n: integer): real;
var
  h, sum, x: real;
  i: integer;
begin
  if b <= a then
  begin
    writeln('Ошибка: b должно быть больше a!');
    LeftRectangles := 0;
    exit;
  end;
  
  if n <= 0 then 
  begin
    writeln('Ошибка: n должно быть больше 0!');
    LeftRectangles := 0;
    exit;
  end;
  
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
  res2: real;
begin
  clrscr;
  
  { Проверка введенных значений }
  if (a = 0) and (b = 0) then
  begin
    writeln('ОШИБКА: Пределы интегрирования не заданы!');
    writeln('Сначала введите a и b в пунктах 1 и 2 меню.');
    readln;
    exit;
  end;
  
  if n = 0 then
  begin
    writeln('ОШИБКА: Количество разбиений не задано!');
    writeln('Сначала введите n в пункте 3 меню.');
    readln;
    exit;
  end;
  
  if b <= a then
  begin
    writeln('ОШИБКА: b должно быть больше a!');
    writeln('a = ', a:0:4, ', b = ', b:0:4);
    readln;
    exit;
  end;
  
  { Вычисление }
  writeln('=== ВЫЧИСЛЕНИЕ ПЛОЩАДИ ===');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('Интервал: [', a:0:4, ', ', b:0:4, ']');
  writeln('Метод: ЛЕВЫЕ прямоугольники, n = ', n);
  writeln('----------------------------------------');
  
  res := LeftRectangles(a, b, n);
  exact := Fx(b) - Fx(a);
  Calculated := true;
  
  { Вывод результатов }
  writeln('РЕЗУЛЬТАТЫ:');
  writeln('  Численный метод (левые прямоуг.): ', res:0:8);
  writeln('  Точное значение (Ньютон-Лейбниц):  ', exact:0:8);
  writeln('  ----------------------------------------');
  
  { Вычисление погрешностей }
  absoluteError := abs(exact - res);
  writeln('  Абсолютная погрешность:   ', absoluteError:0:8);
  
  if exact <> 0 then
  begin
    relativeError := abs(absoluteError / exact) * 100;
    writeln('  Относительная погрешность: ', relativeError:0:4, '%');
  end;
  
  { Дополнительная оценка погрешности через двойное разбиение }
  writeln('  ----------------------------------------');
  writeln('  Оценка погрешности по правилу Рунге:');
  res2 := LeftRectangles(a, b, 2*n);
  writeln('  Для n = ', 2*n, ': ', res2:0:8);
  writeln('  Разность (оценка погрешности): ', abs(res2 - res):0:8);
  
  readln;
end;

{ Процедура оценки погрешности }
procedure EstimateError;
var
  absoluteError, relativeError: real;
  res2, res4, errorEstimate, p: real;
begin
  clrscr;
  
  if not Calculated then
  begin
    writeln('Сначала выполните вычисление площади!');
    readln;
    exit;
  end;
  
  writeln('=== ОЦЕНКА ПОГРЕШНОСТИ ===');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('Интервал: [', a:0:4, ', ', b:0:4, ']');
  writeln('Метод: левые прямоугольники');
  writeln('----------------------------------------');
  
  { 1. Прямое сравнение с точным значением }
  writeln('1. СРАВНЕНИЕ С ТОЧНЫМ ЗНАЧЕНИЕМ:');
  writeln('   Метод левых прямоугольников: ', res:0:10);
  writeln('   Метод Ньютона-Лейбница:      ', exact:0:10);
  
  absoluteError := abs(exact - res);
  writeln('   Абсолютная погрешность:      ', absoluteError:0:10);
  
  if exact <> 0 then
  begin
    relativeError := abs(absoluteError / exact) * 100;
    writeln('   Относительная погрешность:    ', relativeError:0:4, '%');
  end;
  
  { 2. Оценка погрешности по правилу Рунге }
  writeln;
  writeln('2. ОЦЕНКА ПОГРЕШНОСТИ ПО ПРАВИЛУ РУНГЕ:');
  res2 := LeftRectangles(a, b, 2*n);
  res4 := LeftRectangles(a, b, 4*n);
  
  writeln('   Для n = ', n, ':     ', res:0:10);
  writeln('   Для n = ', 2*n, ':   ', res2:0:10);
  writeln('   Для n = ', 4*n, ':   ', res4:0:10);
  
  { Для метода левых прямоугольников погрешность ~ O(h) }
  errorEstimate := abs(res2 - res);
  writeln('   Оценка погрешности (|I_2n - I_n|): ', errorEstimate:0:10);
  
  { Оценка порядка метода }
  if (abs(res4 - res2) > 0) and (abs(res2 - res) > 0) then
  begin
    p := ln(abs((res4 - res2)/(res2 - res))) / ln(2);
    writeln('   Экспериментальный порядок метода: ', p:0:4);
  end;
  
  { 3. Анализ точности }
  writeln;
  writeln('3. АНАЛИЗ ТОЧНОСТИ:');
  if absoluteError < 0.0001 then
    writeln('   Очень высокая точность (ошибка < 0.0001)')
  else if absoluteError < 0.001 then
    writeln('   Высокая точность (ошибка < 0.001)')
  else if absoluteError < 0.01 then
    writeln('   Удовлетворительная точность (ошибка < 0.01)')
  else
    writeln('   Низкая точность (ошибка > 0.01)');
  
  if n < 100 then
    writeln('   Рекомендация: увеличьте n для большей точности');
  
  writeln('========================================');
  
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
  writeln('=== ЛАБОРАТОРНАЯ РАБОТА N3 ===');
  writeln('===      ВАРИАНТ 17         ===');
  writeln('Изучение базовых принципов организации процедур и функций');
  writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
  writeln('----------------------------------------');
  
  { Меню с указателем выбора }
  if sel = 1 then write('-> ') else write('   ');
  writeln('1. Ввести нижний предел (a)');
  
  if sel = 2 then write('-> ') else write('   ');
  writeln('2. Ввести верхний предел (b)');
  
  if sel = 3 then write('-> ') else write('   ');
  writeln('3. Ввести количество разбиений (n)');
  
  if sel = 4 then write('-> ') else write('   ');
  writeln('4. Вычислить площадь (метод левых прямоуг.)');
  
  if sel = 5 then write('-> ') else write('   ');
  writeln('5. Оценить погрешность');
  
  if sel = 6 then write('-> ') else write('   ');
  writeln('6. Выход');
  
  writeln('----------------------------------------');
  writeln('ТЕКУЩИЕ ПАРАМЕТРЫ:');
  
  { Показываем только если значения введены }
  if (a <> 0) or (b <> 0) or (n <> 0) then
  begin
    writeln('  a = ', a:0:4, '    b = ', b:0:4, '    n = ', n);
  end
  else
  begin
    writeln('  a = не задано    b = не задано    n = не задано');
  end;
  
  if Calculated then
  begin
    writeln('----------------------------------------');
    writeln('ПОСЛЕДНИЙ РЕЗУЛЬТАТ:');
    writeln('  Площадь = ', res:0:6, '   Погрешность = ', abs(exact-res):0:6);
  end;
  
  writeln('----------------------------------------');
  writeln('Управление: стрелки вверх/вниз, Enter');
end;

{ Основная программа }
begin
  { Инициализация переменных нулевыми значениями }
  a := 0.0;
  b := 0.0;
  n := 0;
  sel := 1;
  Calculated := false;
  
  while true do
  begin
    DisplayMenu;
    ch := ReadKey;
    
    if ch = #0 then
      ch := ReadKey;
    
    case ch of
      #38: { Вверх }
        if sel > 1 then sel := sel - 1 else sel := 6;
      
      #40: { Вниз }
        if sel < 6 then sel := sel + 1 else sel := 1;
      
      #13: { Enter }
        case sel of
          1: { Ввод a }
          begin
            clrscr;
            writeln('ВВОД НИЖНЕГО ПРЕДЕЛА (a):');
            writeln('Функция: y = 1*x^3 + (-2)*x^2 + 0*x + 4');
            writeln('a должно быть меньше b');
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
            writeln('b должно быть больше a');
            writeln;
            write('Введите b: ');
            readln(b);
            Calculated := false;
          end;
          
          3: { Ввод n }
          begin
            clrscr;
            writeln('ВВОД КОЛИЧЕСТВА РАЗБИЕНИЙ (n):');
            writeln('Метод: ЛЕВЫЕ прямоугольники');
            writeln('Чем больше n, тем точнее результат');
            writeln('Рекомендуется: 100-10000');
            writeln;
            write('Введите n: ');
            readln(n);
            if n <= 0 then 
            begin
              writeln('Ошибка: n должно быть больше 0!');
              n := 0;
              readln;
            end;
            Calculated := false;
          end;
          
          4: CalculateArea;    { Вычисление площади }
          
          5: EstimateError;    { Оценка погрешности }
          
          6: ExitProgram;      { Выход }
        end;
    end;
  end;
end.