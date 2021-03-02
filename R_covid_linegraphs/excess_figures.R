library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

library('surveillance')
library(readr)
library(tidyr)
library(dplyr)

start_idx<-wb[[1]]
end_idx<-wb[[2]]
cistring<-paste(c(as.character(ci_raw),"% CI Upper Bound of ",as.character(b),"-Year Trend"),collapse="")
alpha<-1.00-ci_raw/100
counts_filtered<-filter(counts,Type==weighted)
counts_filtered<-filter(counts_filtered,`Jurisdiction` == jurisdiction)
counts_filtered<-filter(counts_filtered,`Cause Subgroup` == cause)
#remove extraneous columns
counts_filtered<-counts_filtered[,!colnames(counts_filtered) %in% c('Week Ending Date','Type','Jurisdiction','State Abbreviation','Cause Group','Time Period','Suppress','Note','Average Number of Deaths in Time Period','Difference from 2015-2019 to 2020','Percent Difference from 2015-2019 to 2020')]
counts_wider = pivot_wider(counts_filtered,names_from=`Cause Subgroup`,values_from='Number of Deaths',values_fn=(`Cause Subgroup`=sum))
counts_wider[is.na(counts_wider)]<-0
end<-dim(counts_wider)[1]
freq<-max(counts_wider[,'Week'])
#but "observed" must be a numeric matrix
numeric_data<-data.matrix(counts_wider)[order(counts_wider[,'Year'],counts_wider[,'Week']),]
numeric_data<-numeric_data[,!colnames(numeric_data) %in% c('Week','Year')]
#strip out now-extraneous columns
#numeric_data<-numeric_data[,'Number of Deaths']
start<-c(min(counts_wider[,'Year']),min(counts_wider[,'Week']))
sts <- new("sts",epoch=1:end,freq=52,start=start,observed=numeric_data)
title_str<-paste(c(cause,"-coded"," mortality in ",jurisdiction),collapse="")
#Sparse data creates a couple problems:
##1) not all jurisdictions have the most recent weeks -- indeed, they may not have data going way back. I address for this by comparing the indices against the data frame size after the jurisdiction and cause filters have been applied. When mismatches like this occur, I add a note to the graph's title.
##2) the other problem is harder to catch -- insufficient data for the farrington algorithm to work. I use an error handler for that, and throw back an empty graph
	if(end<end_idx){
		gap<-end_idx - start_idx
		end_idx<-end
		if(start_idx>end_idx){
			start_idx<-max(1,end_idx-gap)
		}
		title_str<-paste(c(title_str,"**data is sparse here**"),collapse=" ")
	}
	cntrlFar <- list(range=start_idx:end_idx,start=start,w=w,b=b,alpha=alpha)
	fig <- plot_ly()
	y_axis_title<-paste(c(weighted, " Deaths"),collapse="")

print(y_axis_title)

		surveil_sts_far <- farrington(sts,control=cntrlFar)
		far_df<-tidy.sts(surveil_sts_far)

		week_averages<-list()
		for(week in unique(far_df$epochInYear)){
			t<-filter(counts_wider,Week==week)
			a<-t%>%slice((nrow(t)-b):(nrow(t)-1))
			r<-mean(a%>%pull(cause))
			week_averages[[length(week_averages)+1]]<-r
		}
		wkavg<-as.numeric(unlist(week_averages))

		weds<-far_df$date

		obs<-far_df$observed
		upperb<-far_df$upperbound
		
		if (excess_measure=="Average") {
			normal<-wkavg
			excess_measure_string<-c("average")
		} else {
			excess_measure_string<-c(as.character(ci_raw),"% CI")
			normal<-upperb
		}
		
		excess<-obs-normal
		excess[excess<0]<-0
		
		print(normal)
		print(obs)
		print(excess)
		
		cum_excess=round(sum(excess))
		title_str<-paste(c(title_str,":",cum_excess,"cumulative excess deaths."),collapse=" ")
		
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
			name=paste(c("'Normal' mortality using ",excess_measure_string," on ",as.character(b)," years' data"),collapse="")
		)
		fig <- fig %>% add_trace(
			stackgroup='one',
			x=weds,
			y=excess,
			mode='none',
			name=paste(c(weighted," \"Excess\" mortality"),collapse="")
		)

