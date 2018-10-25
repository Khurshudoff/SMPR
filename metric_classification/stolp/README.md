# STOLP

## Основные определения
**Отступ** - степень погруженности объекта в свой класс. Отступ будем обозначать: 
<div style="text-align: center">  <img src="https://latex.codecogs.com/gif.latex?{\color{Red}M(x_i,\Omega&space;)}" title="M(x_i,\Omega )" /></div>

Отступ вычисляется как: 
<div style="text-align: center"> <img src="https://latex.codecogs.com/gif.latex?{\color{Red}M(x_i,\Omega&space;)&space;=\Gamma_{x_i}&space;-&space;\max_{y\in&space;Y&space;\backslash&space;y_i}&space;\Gamma_y(x_i)}" title="M(x_i,\Omega ) =\Gamma_{x_i} - \max_{y\in Y \backslash y_i} \Gamma_y(x_i)" />, где: </div>

1. <img src="https://latex.codecogs.com/gif.latex?{\color{Red}x_i}" title="x_i" /> - объект
2. <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\Omega}" title="\Omega" /> - обучающая выборка
3. <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\Gamma_y(x)&space;=&space;\sum_{i=1}^l&space;[y^{(i)}&space;=&space;y]w(i,x)}" title="\Gamma_y(x) = \sum_{i=1}^l [y^{(i)} = y]w(i,x)" />
4. <img src="https://latex.codecogs.com/gif.latex?{\color{Red}w(i,x)}" title="w(i,x)" /> - вес i-го соседа объекта х

## Построение графика для объектов обучения относительно Парзеновского классификатора с Гауссовским ядром

```R
margin <- function(x, my_iris, k) {
  l <- dim(my_iris)[1]
  n <- dim(my_iris)[2] - 1
  
  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")
  
  for (i in 1:l){
    curObjClass = my_iris[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernelGaussian(my_iris[i,1:2], x[,1:2], metricFunction=euclideanDistance, h=0.1)
  }
  
  namesD = names(d)
  
  dCur <- which(namesD %in% x$Species)
  
  sortedCounts = sort(d[-dCur])
  
  return(d[x[, 3]] - sortedCounts[2])
}
```

<img src="img/parsenMargin1500.png">

## STOLP описание алгоритма
### Вход:
1. Выборка <img src="https://latex.codecogs.com/gif.latex?{\color{Red}X^l}" title="X^l" />,
2. Допустимая доля ошибок <img src="https://latex.codecogs.com/gif.latex?{\color{Red}l_0}" title="l_0" />,
3. Порог отсечения выбросов <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\delta}" title="\delta" />,
4. Алгоритм классификации <img src="https://latex.codecogs.com/gif.latex?{\color{Red}a}" title="a" />,
5. Формула для вычисления риска <img src="https://latex.codecogs.com/gif.latex?{\color{Red}W}" title="W" />.

### Выход:
1. Множество эталонов <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\Omega}" title="\Omega" />.

### Описание работы алгоритма:
1. Создаем n множеств и добавляем в каждое из них объекты одного класса. Для каждого объекта считаем его отступ. Множеств обозначим <img src="https://latex.codecogs.com/gif.latex?{\color{Red}&space;\Phi_n}" title="{\color{Red} \Phi_n}" />.
2. Отбросить все выбросы, т.е. объекты у которых <img src="https://latex.codecogs.com/gif.latex?\color{Red}W&space;>\delta" title="\color{Red}W >\delta" />
3. Сформировать <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\Omega}" title="\Omega" />. Из каждого класса выбираем объект с наименьшей величиной риска.
4. Наращиваем множество этолонов <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\Omega}" title="\Omega" /> до тех пор, пока число объектов выборки <img src="https://latex.codecogs.com/gif.latex?{\color{Red}X^l}" title="X^l" /> классифицируемых неправльно не станет меньше, чем <img src="https://latex.codecogs.com/gif.latex?{\color{Red}l_0}" title="l_0" />:
+  Выбираем класс, объекты которого чаще других распознаются неправильно. В этом классе выбираем объект с максимальной величиной риска и добавляем его во множество эталонов,
+ Удаляем этот из соответсвующего ему множества <img src="https://latex.codecogs.com/gif.latex?{\color{Red}&space;\Phi_n}" title="{\color{Red} \Phi_n}" />. 

### Рассмотрим пример работы алгоритмы для окна парзены с гауссовским ядром:
#### Параметры:

1. Выборка <img src="https://latex.codecogs.com/gif.latex?{\color{Red}X^l}" title="X^l" /> - __Ирисы Фишера__,
2. Допустимая доля ошибок <img src="https://latex.codecogs.com/gif.latex?{\color{Red}l_0}" title="l_0" /> = __5__,
3. Порог отсечения выбросов <img src="https://latex.codecogs.com/gif.latex?{\color{Red}\delta}" title="\delta" /> - __отсечем 4% всех оюъектов__,
4. Алгоритм классификации <img src="https://latex.codecogs.com/gif.latex?{\color{Red}a}" title="a" /> - __окно парзена с гауссовским окном(h=0.1)__,
5. Формула для вычисления риска <img src="https://latex.codecogs.com/gif.latex?{\color{Red}W}&space;=-&space;{\mathbf&space;M(x_i,\Omega)}" title="{\color{Red}W} =- {\mathbf M(x_i,\Omega)}" />

[1] "3  ||||  false positive =  8 / 150  =  0.053"
[1] "4  ||||  false positive =  7 / 150  =  0.047"
[1] "5  ||||  false positive =  7 / 150  =  0.047"
[1] "6  ||||  false positive =  7 / 150  =  0.047"
[1] "7  ||||  false positive =  7 / 150  =  0.047"
[1] "8  ||||  false positive =  7 / 150  =  0.047"
[1] "9  ||||  false positive =  5 / 150  =  0.033"
[1] "10  ||||  false positive =  5 / 150  =  0.033"
[1] "11  ||||  false positive =  5 / 150  =  0.033"
[1] "12  ||||  false positive =  5 / 150  =  0.033"
[1] "13  ||||  false positive =  4 / 150  =  0.027"

| Шаг | Количество элементов  во множестве эталонов | Ошибка |
| --- | ------ |----------------|
| 1   | 3      | 8/150 = 0.053  |
| 2   | 4      | 7/150 = 0.047   |
| 3   | 5      | 7/150 = 0.047   |
| 4   | 6      | 7/150 = 0.047   |
| 5   | 7      | 7/150 = 0.047   |
| 6   | 8      | 7/150 = 0.047   |
| 7   | 9      | 5/150 = 0.033   |
| 8   | 10     | 5/150 = 0.033   |
| 9   | 11     | 5/150 = 0.033   |
| 10  | 12     | 5/150 = 0.033   |
| 11  | 13     | 4/150 = 0.027   |

### Шаг 1: __3 объекта__ во множестве эталонов, __точность 0.053__
<img src="img/parsen_01.png">

### Шаг 2: __4 объекта__ во множестве эталонов, __точность 0.047__
<img src="img/parsen_02.png">

### Шаг 3: __5 объектов__ во множестве эталонов, __точность 0.047__
<img src="img/parsen_03.png">

### Шаг 4: __6 объектов__ во множестве эталонов, __точность 0.047__
<img src="img/parsen_04.png">

### Шаг 5: __7 объектов__ во множестве эталонов, __точность 0.047__
<img src="img/parsen_05.png">

### Шаг 6: __8 объектов__ во множестве эталонов, __точность 0.047__
<img src="img/parsen_06.png">

### Шаг 7: __9 объектов__ во множестве эталонов, __точность 0.033__
<img src="img/parsen_07.png">

### Шаг 8: __10 объектов__ во множестве эталонов, __точность 0.033__
<img src="img/parsen_08.png">

### Шаг 9: __11 объектов__ во множестве эталонов, __точность 0.033__
<img src="img/parsen_09.png">

### Шаг 10: __12 объектов__ во множестве эталонов, __точность 0.033__
<img src="img/parsen_10.png">

### Шаг 11: __13 объектов__ во множестве эталонов, __точность 0.027__
<img src="img/parsen_11.png">

## Сравнение скорости работы и точности

Для измерения скорости работы я использовал встроенную в R функцию __Sys.time()__. Для парзеновского окна без выбора эталоном она показала время работы 11.2 сек. После выбора эталонов был достигнут значительный прирост в скорости работы, а именно было получено значение 0.75 сек.

Для измерения качества работы я использовал метрику точности, т.е. долю правильных ответов. Как до применение алгоритма STOLP, так и после точность не изменилась и была равна 0.97, что является лучшим показателем для этих входных данных