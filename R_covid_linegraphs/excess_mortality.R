library(plotly)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
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

print(counts)

steps_back_slider_opts<-list()
idx<-0
wed<-week_ending_dates[(length(week_ending_dates)-max_steps_back):length(week_ending_dates)]
for(i in wed){
	d<-as.Date(i,origin='1970-01-01')
	steps_back_slider_opts[[length(steps_back_slider_opts)+1]]<-list(label=d,value=idx)
	idx<-idx+1
}


min_start_idx<-length(week_ending_dates)-max_steps_back
max_end_idx<-length(week_ending_dates)
wb<-list(min_start_idx,max_end_idx)


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

excess_radio_opts<-list(list(label='Upper Bound of 95% CI',value='Farrington'),list(label='Average',value='Average'))

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
                        htmlLabel('Graph Type'),
						dccDropdown(
							id = 'graph_type',
							options = list(
									list('label'='Stacked Lines','value'='stackedlines'),
									list('label'='Stacked Bars','value'='stackedbars')									),
							value = 'stackedlines'
							)  
                ),style=list('columnCount'=2,'width'='100%','marginTop'=15,'marginBottom'=15)
        )
	))
)

        
app$callback(
	output = list(id='fizz',property='figure'),
	params = list(
		input(id='cause_dropdown',property='value'),
		input(id='jurisdiction_dropdown',property='value'),
		input(id='weighted_radio',property='value'),
		input(id='graph_type',property='value')
	),
	function(cause,jurisdiction,weighted,graph_type) {

		result = tryCatch({

			cause<-cause
			jurisdiction<-jurisdiction
			weighted<-weighted
		
			
				source("excess_stacked.R",local=TRUE)
				result<-fig
			

		}, error = function(e) {
				print("ERROR ERROR ERROR")
				list(
					layout=list(
						title="DATA TOO SPARSE TO RENDER GRAPH WITH THESE SPECIFIC PARAMETERS",
						xaxis=list('title'='Week Ending Date'),
						yaxis=list('title'='Deaths'),
						paper_bgcolor = '#c3d1e8'
					),
					data = list()
				)
		})

	}
)

app$run_server(host='0.0.0.0',port=Sys.getenv('PORT',8050))



