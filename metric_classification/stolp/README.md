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

```
margin <- function(x, my_iris, k) {
  l <- dim(my_iris)[1]
  n <- dim(my_iris)[2] - 1

  d <- c(0.0,0.0,0.0)
  names(d) <- c("setosa", "versicolor", "virginica")

  for (i in 1:l){
    curObjClass = my_iris[i, n+1]
    d[curObjClass] <- d[curObjClass] + kernelGaussian(my_iris[i,1:2], x[,1:2], metricFunction=euclideanDistance, h=0.1)
  }

  sortedCounts = sort(d)
  
  return(sortedCounts[3] - sortedCounts[2])
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
2. Отбросить все выбросы, т.е. объекты у которых <img src="https://latex.codecogs.com/gif.latex?{\color{Red}W >\delta}" title="\delta" />.
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
5. Формула для вычисления риска <img src="https://latex.codecogs.com/gif.latex?{\color{Red}W} =- {\mathbf M(x_i,\Omega&space;)}" title="M(x_i,\Omega )">.

| Количество элементов  во множестве эталонов | Ошибка |
| ------ |----------------|
| 3      | 100/150 = 0.67 |
| 4      | 100/150 = 0.67 |
| 5      | 50/150 = 0.33  |
| 6      | 7/150 = 0.05   |
| 7      | 4/150 = 0.03   |

<img src="img/parsenFirstStep1500.png">
<img src="img/parsenSecondStep1500.png">
<img src="img/parsenThirdStep1500.png">
<img src="img/parsenFourthStep1500.png">
<img src="img/parsenFifthStep1500.png">

Time difference of 0.510514 secs

Time difference of 11.26882 secs

[1] "sigma = 0.404"
[1] "3  ||||  false positive =  100 / 150  =  0.667"
[1] "4  ||||  false positive =  100 / 150  =  0.667"
[1] "5  ||||  false positive =  50 / 150  =  0.333"
[1] "6  ||||  false positive =  7 / 150  =  0.047"
[1] "7  ||||  false positive =  4 / 150  =  0.027"
[1] "accuracy = 0.97"
Time difference of 0.593384 secs