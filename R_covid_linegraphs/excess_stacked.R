library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(readr)
library(tidyr)
library(dplyr)

#jurisdiction<-"Texas"
#cause<-"Diabetes"
#weighted<-"Unweighted"

counts <- read_csv("Weekly_counts_of_death_by_jurisdiction_and_cause_of_death.csv")

observed <- filter(counts,`Type`==weighted,`Jurisdiction`==jurisdiction,`Cause Subgroup`==cause,`Year`>=2020)
observed <- observed %>% select(`Number of Deaths`,`Week`,`Week Ending Date`,`Year`)
observed <- arrange(observed,`Year`,`Week`)

comparison <- filter(counts,`Type`==weighted,`Jurisdiction`==jurisdiction,`Cause Subgroup`==cause,`Year`<2020)
comparison <- comparison  %>% select(`Number of Deaths`,`Week`)
comparison <- comparison %>% group_by(Week) %>% summarize('Number of Deaths'=mean(`Number of Deaths`))
comparison <- arrange(comparison,`Week`)

rowdiff=nrow(observed)-nrow(comparison)
padded<-rbind(comparison,head(comparison,rowdiff))
normal<-data.matrix(observed$`Number of Deaths`)

print(nrow(observed))
print(nrow(normal))
print(nrow(comparison))

excess<-normal-data.matrix(padded$`Number of Deaths`)
excess[excess<0]<-0


fig <- plot_ly()
cum_excess=round(sum(excess))

weds<-observed$`Week Ending Date`
y_axis_title<-paste(c(weighted, " Deaths"),collapse="")

cum_excess=round(sum(excess))

title_str<-paste(c(cause,"-coded"," mortality in ",jurisdiction,": ",cum_excess," cumulative excess deaths."),collapse="")

if (graph_type=="stackedlines"){

	fig <- fig %>% layout(
		title=title_str,
		xaxis=list('title'='Week Ending Date'),
		yaxis=list('title'=y_axis_title),
		paper_bgcolor = '#c3d1e8',
		type='scatter',
		stackgroup='one'
	)
	fig <- fig %>% add_trace(
		stackgroup='one',
		x=weds,
		y=normal,
		mode='none',
		name=paste(c("Average mortality, 2015-2019"),collapse="")
	)
	fig <- fig %>% add_trace(
		stackgroup='one',
		x=weds,
		y=excess,
		mode='none',
		name=paste(c(weighted," \"Excess\" mortality"),collapse="")
	)
	
} else if (graph_type=="stackedbars") {

	fig <- fig %>% layout(
				title=title_str,
				xaxis=list('title'='Week Ending Date'),
				yaxis=list('title'=y_axis_title),
				paper_bgcolor = '#c3d1e8',
				type='bar',
				barmode='stack'
			)
	fig <- fig %>% add_trace(
		x=weds,
		y=normal,
		type='bar',
		name=paste(c("Average mortality, 2015-2019"),collapse="")
	)
	fig <- fig %>% add_trace(
		x=weds,
		y=excess,
		type='bar',
		name=paste(c(weighted," \"Excess\" mortality"),collapse="")
	)

}