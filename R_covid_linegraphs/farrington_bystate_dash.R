library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)

library('surveillance')
library(readr)
library(tidyr)
library(dplyr)

app<-Dash$new()
fig<-plot_ly()

w<-1
nfreq<-52
#can't go back more than a year without breaking my fragile averaging function at the bottom
##please, fix it! (or, better, put: lowerbound and mean in sts surveillance farrington)
max_steps_back<-51
steps_back<-40

counts <- read_csv("Weekly_counts_of_death_by_jurisdiction_and_cause_of_death.csv")
week_ending_dates<-unique(counts$`Week Ending Date`[order(counts$Year,counts$Week)])

steps_back_slider_opts<-list()
idx<-0
wed<-week_ending_dates[(length(week_ending_dates)-max_steps_back):length(week_ending_dates)]
for(i in wed){
	d<-as.Date(i,origin='1970-01-01')
	steps_back_slider_opts[[length(steps_back_slider_opts)+1]]<-list(label=d,value=idx)
	idx<-idx+1
}


stepsback_sliderlabels<-list()
min_start_idx<-length(week_ending_dates)-max_steps_back
max_end_idx<-length(week_ending_dates)


for(i in min_start_idx:max_end_idx){
	stepsback_sliderlabels[[i]]<-week_ending_dates[i]
}



causes<-unique(counts$`Cause Subgroup`)
cause_dropdown_opts<-list()
for(i in causes){
	cause_dropdown_opts[[length(cause_dropdown_opts)+1]]<-list(label=i,value=i)
}

jurisdictions<-unique(counts$`Jurisdiction`)
jurisdiction_dropdown_opts<-list()
for(i in jurisdictions){
	jurisdiction_dropdown_opts[[length(jurisdiction_dropdown_opts)+1]]<-list(label=i,value=i)
}

excess_radio_opts<-list(list(label='Farrington CI Upperbound',value='Farrington'),list(label='Average',value='Average'))

weighted_opts<-unique(counts$`Type`)
weighted_radio_opts<-list()
for(i in weighted_opts){
	weighted_radio_opts[[length(weighted_radio_opts)+1]]<-list(label=i,value=i)
}

ci_sliderlabels<-list()
for(i in 50:100){ci_sliderlabels[[i]]<-as.character(i-1)}

yearsback_sliderlabels<-list()
for(i in 1:4){yearsback_sliderlabels[[i]]<-as.character(i-1)}



app$layout(
	htmlDiv(list(

	htmlDiv(list(
			dccGraph(id='fizz',figure=fig)
		)),
	htmlDiv(
		list(
			htmlLabel('Listed Cause of Death'),
			dccDropdown(
				id = 'cause_dropdown',
				options = cause_dropdown_opts,
				value = 'Diabetes'
			),
			htmlLabel('State'),
			dccDropdown(
				id = 'jurisdiction_dropdown',
				options = jurisdiction_dropdown_opts,
				value = "Texas"
			)
		),style=list('columnCount'=2,'width'='100%','marginTop'=15,'marginBottom'=15)
	),
	htmlDiv(
                list(
                        htmlLabel('Weighted or Raw Counts'),
                        dccRadioItems(
                                id = 'weighted_radio',
                                options = weighted_radio_opts,
                                value = "Unweighted"
                        ),
                        htmlLabel('Measure of Excess'),
                        dccRadioItems(
                                id = 'excess_radio',
                                options = excess_radio_opts,
                                value = 'Farrington'
                        )
                ),style=list('columnCount'=2,'width'='100%','marginTop'=15,'marginBottom'=15)
        ),
	htmlDiv(
		list(
                        htmlLabel('Base Trendline on # Years of Previous Data'),
                        dccSlider(
                                id = 'yearsback_slider',
                                min = 1,
                                max = 3,
                                marks = yearsback_sliderlabels,
                                value = 3,
				included= FALSE
                        )

                ),style=list('width'='90%','marginTop'=15,'marginBottom'=15)
        ),
	htmlDiv(
                list(
                        htmlLabel('Confidence Interval on Trend'),
                        dccSlider(
                                id = 'ci_slider',
                                min = 50,
                                max = 99,
				value=95,
				marks=ci_sliderlabels
                        )
                ),style=list('width'='100%','marginTop'=15)
        ),
	htmlDiv(
                list(
                        htmlLabel('Date Range'),
			dccRangeSlider(
                                id = 'weeks_slider',
                                min = min_start_idx,
                                max = max_end_idx,
                                value = list(min_start_idx,max_end_idx)
                        )
		),style=list('width'='100%','marginTop'=15)
	)
	))
)

app$callback(
	output = list(id='fizz',property='figure'),
	params = list(
		input(id='cause_dropdown',property='value'),
		input(id='jurisdiction_dropdown',property='value'),
		input(id='weighted_radio',property='value'),
		input(id='ci_slider',property='value'),
		input(id='yearsback_slider',property='value'),
		input(id='weeks_slider',property='value'),
		input(id='excess_radio',property='value')
	),
	function(cause,jurisdiction,weighted,ci_raw,b,wb,excess_measure) {
		cause<-cause
		jurisdiction<-jurisdiction
		weighted<-weighted
		ci_raw<-ci_raw
		b<-b
		wb<-wb
		w<-w
		excess_measure<-excess_measure
		source("excess_figures.r",local=TRUE)
		result<-fig
		results<-fig
	}
)

app$run_server(host='0.0.0.0',port=Sys.getenv('PORT',8050))



