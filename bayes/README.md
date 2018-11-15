# Байесовский классификатор
Байесовский классификатор — класс алгоритмов классификации, основанных на принципе максимума апостериорной вероятности. Все эти алгоритмы построены на формуле байеса приведенной ниже
## Формула Байеса
<img src="https://latex.codecogs.com/gif.latex?p(y|x)=\frac{p(x,y)}{p(x)}&space;=&space;\frac{p(x|y)p(y)}{p(x)}" title="p(y|x)=\frac{p(x,y)}{p(x)} = \frac{p(x|y)p(y)}{p(x)}" /></a>
1. <img src="https://latex.codecogs.com/gif.latex?p(y|x)"/></a> - Апостериорная вероятности, т.е. вероятность того, что объект x принадлежит классу y.
2. <img src="https://latex.codecogs.com/gif.latex?p(x|y)"/></a> - функция правдободобия.
3. <img src="https://latex.codecogs.com/gif.latex?p(y)"/></a> - Априорная вероятность, т.е. вероятность появления класса.

<img src="https://latex.codecogs.com/gif.latex?Aposterior&space;=&space;\frac{Likehood&space;\times&space;Prior}{Evidence}"/></a>

## Линии уровня нормального распределения

<a href="http://khurshudoff.shinyapps.io/2d_lines">Визуализация линий уровня нормального распределния</a>
<img src="gaussian_distribution/2D_lines/2D-lines.png">