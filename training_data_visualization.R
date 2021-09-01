library(gapminder)
library(Lahman)
library(nycflights13)
library(tidyverse)

#Data Visualization
##basic ggplot system
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=hwy, y=cyl))  
ggplot(data=mpg)+
  geom_point(mapping=aes(x=class, y=drv))

##changing aesthetics
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, color=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, size=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, alpha=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, shape=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy), color="blue")
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, shape=class, color=class))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, stroke=cyl))
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy, color=displ<5))

##using facet to put multiple plots on one screen
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  facet_wrap(~class, nrow=2)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  facet_grid(drv~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  facet_grid(.~cyl)
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  facet_grid(drv~.)

#compare different geoms
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy, lty=drv, color=drv))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy, group=drv))
ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y=hwy, color=drv), show.legend=FALSE)

##multiple geoms in one plot
ggplot(data=mpg)+
  geom_point(mapping=aes(x=displ, y=hwy))+
  geom_smooth(mapping=aes(x=displ, y=hwy))
###combine to streamline if edits are needed
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth()
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth()
###specify different data for different geom layers
ggplot(data=mpg, mapping=aes(x=displ, y=hwy))+
  geom_point(mapping=aes(color=class))+
  geom_smooth(data=filter(mpg, class=="subcompact"), se=FALSE)

ggplot(data=mpg, mapping=aes(x=displ, y=hwy, color=drv))+
  geom_point()+
  geom_smooth()
###adding "se=FALSE" takes off the confidence bands around lines
ggplot(data=mpg, mapping=aes(x=displ, y=hwy, color=drv))+
  geom_point()+
  geom_smooth(se=FALSE)

##Statistical transformation
ggplot(diamonds)+
  geom_bar(aes(x=cut))
ggplot(diamonds)+
  stat_count(aes(x=cut))
###may want to change the default geom settings using stat
ggplot(diamonds)+
  geom_bar(aes(x=cut,y=stat(prop),group=1))

##draw attention to the statistical transformation
ggplot(diamonds)+
  stat_summary(
    aes(x=cut, y=depth),
    fun.min=min,
    fun.max=max,
    fun=median
  )
ggplot(diamonds)+
  geom_pointrange(
    mapping=aes(x=cut, y=depth),
    stat="summary",
    fun.min=min,
    fun.max=max,
    fun=median
  )

###adjusting colors of charts
ggplot(diamonds)+
  geom_bar(aes(x=cut, color=cut))
ggplot(diamonds)+
  geom_bar(aes(x=cut, fill=cut))
ggplot(diamonds)+
  geom_bar(aes(x=cut, fill=clarity))
ggplot(diamonds, aes(x=cut, fill=clarity))+
  geom_bar(alpha=1/5, position="identity")
ggplot(diamonds, aes(x=cut, color=clarity))+
  geom_bar(fill=NA, position="identity")
###adjusting the look of charts to better read data
ggplot(diamonds)+
  geom_bar(aes(x=cut,fill=clarity), position="fill")
ggplot(diamonds)+
  geom_bar(aes(cut, fill=clarity), position="dodge")
ggplot(mpg)+
  geom_point(aes(displ,hwy), position="jitter")
###^same as...
ggplot(mpg)+
  geom_jitter(aes(displ,hwy))

##Coordinate Systems
ggplot(mpg, aes(class,hwy))+
  geom_boxplot()
ggplot(mpg, aes(class, hwy))+
  geom_boxplot()+
  coord_flip()