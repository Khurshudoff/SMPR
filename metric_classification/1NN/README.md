<h1>Метрические классификаторы:</h1>

<h2>Гипотеза компактности:</h2>
<p>близкие объекты, как правило, лежат в одном классе</p>

<h2>Обобщенный метрический алгоритм классификации:</h2>
Для произвольного <a href="https://www.codecogs.com/eqnedit.php?latex=x\in&space;X" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x\in&space;X" title="x\in X" /></a> отранжируем объекты <a href="https://www.codecogs.com/eqnedit.php?latex=x_1,x_2,...x_l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_1,x_2,...x_l" title="x_1,x_2,...x_l" /></a>: 

<br> <div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex=$$\rho&space;(&space;x,x^{(1)}&space;)\leq&space;\rho&space;(&space;x,x^{(2)}&space;)\leq&space;...&space;\leq&space;\rho&space;(&space;x,x^{(l)}&space;)$$" target="_blank"><img src="https://latex.codecogs.com/gif.latex?$$\rho&space;(&space;x,x^{(1)}&space;)\leq&space;\rho&space;(&space;x,x^{(2)}&space;)\leq&space;...&space;\leq&space;\rho&space;(&space;x,x^{(l)}&space;)$$" title="$$\rho ( x,x^{(1)} )\leq \rho ( x,x^{(2)} )\leq ... \leq \rho ( x,x^{(l)} )$$" /></a>,</div>

<ul>где:
	<li><a href="https://www.codecogs.com/eqnedit.php?latex=\rho&space;(x,x_i)&space;=&space;\sqrt{\sum_{j=1}^{n}&space;\left&space;|&space;x^j&space;-&space;x_i^j&space;\right&space;|^2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\rho&space;(x,x_i)&space;=&space;\sqrt{\sum_{j=1}^{n}&space;\left&space;|&space;x^j&space;-&space;x_i^j&space;\right&space;|^2}" title="\rho (x,x_i) = \sqrt{\sum_{j=1}^{n} \left | x^j - x_i^j \right |^2}" /></a></li>
	<li><a href="https://www.codecogs.com/eqnedit.php?latex=x^{(i)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x^{(i)}" title="x^{(i)}" /></a> - i-й сосед объекта х на <a href="https://www.codecogs.com/eqnedit.php?latex=x_1,&space;x_2,&space;...&space;,&space;x_l" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_1,&space;x_2,&space;...&space;,&space;x_l" title="x_1, x_2, ... , x_l" /></a></li>
	<li><a href="https://www.codecogs.com/eqnedit.php?latex=y^{(i)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?y^{(i)}" title="y^{(i)}" /></a> - ответ на i-м соседе объекта х.</li>
</ul>

<h3>Метрический алгоритм классификации:</h3>
<div align="center"><a href="https://www.codecogs.com/eqnedit.php?latex={\color{Red}&space;a(x;X^l)&space;=&space;arg\max_{y\in&space;Y}{\sum_{i=1}^{l}{\left&space;[&space;y^{(i)}&space;=&space;y&space;\right&space;]&space;w(i,x))&space;}&space;}&space;}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?{\color{Red}&space;a(x;X^l)&space;=&space;arg\max_{y\in&space;Y}{\sum_{i=1}^{l}{\left&space;[&space;y^{(i)}&space;=&space;y&space;\right&space;]&space;w(i,x))&space;}&space;}&space;}" title="{\color{Red} a(x;X^l) = arg\max_{y\in Y}{\sum_{i=1}^{l}{\left [ y^{(i)} = y \right ] w(i,x)) } } }" /></a>, </div>

<ul>
	<li><a href="https://www.codecogs.com/eqnedit.php?latex=\Gamma&space;_y&space;(x)&space;=&space;{\sum_{i=1}^{l}{\left&space;[&space;y^{(i)}&space;=&space;y&space;\right&space;]&space;w(i,x))&space;}&space;}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\Gamma&space;_y&space;(x)&space;=&space;{\sum_{i=1}^{l}{\left&space;[&space;y^{(i)}&space;=&space;y&space;\right&space;]&space;w(i,x))&space;}&space;}" title="\Gamma _y (x) = {\sum_{i=1}^{l}{\left [ y^{(i)} = y \right ] w(i,x)) } }" /></a> - оценка близости объекта x к классу y.</li>
	<li><a href="https://www.codecogs.com/eqnedit.php?latex={\color{Red}&space;w(i,x)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?{\color{Red}&space;w(i,x)}" title="{\color{Red} w(i,x)}" /></a> - вес (степень важности) i-го соседа объекта x, неотрицателен и не возрастает по i.</li>
</ul>

<h2>1NN</h2>

<a href="https://www.codecogs.com/eqnedit.php?latex=w(i,x)&space;=&space;[i\leq&space;1]" target="_blank"><img src="https://latex.codecogs.com/gif.latex?w(i,x)&space;=&space;[i\leq&space;1]" title="w(i,x) = [i\leq 1]" /></a> - метод 1NN

<h3>Дано:</h3>
<ul>
	<li>X - объекты</li>
	<li>Y - ответы</li>
	<li><a href="https://www.codecogs.com/eqnedit.php?latex=X^l&space;=&space;(x_i,y_i)_{i=1}^{l}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?X^l&space;=&space;(x_i,y_i)_{i=1}^{l}" title="X^l = (x_i,y_i)_{i=1}^{l}" /></a> - обучающая выборка</li>
</ul>

<h3>Найти:</h3>
<ul>
	<li>Класс нового объекта х</li>
</ul>

<h3>Плюсы:</h3>
<ul>
	<li>Простота реализации</li>
	<li>O(1) - время обучения</li>
</ul>

<h3>Минусы:</h3>
<ul>
	<li>Неустойчивость</li>
	<li>Требуется хранить всю выборку</li>
	<li>требуется O(n) времени на вычисление класса нового объекта</li>
</ul>