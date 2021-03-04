import os
import dash
import dash_core_components as dcc
import dash_html_components as html
import sankey_airtable_citations as SA
import plotly.graph_objects as go

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)

server = app.server

port=int(os.environ.get("PORT",5000))

app.layout = html.Div([
    dcc.Slider(id='threshold',min=1,max=15,step=1,value=8),
    html.Div(dcc.Graph(id='sg'))
    ])

@app.callback(dash.dependencies.Output('sg', 'figure'),
              [dash.dependencies.Input('threshold', 'value')])
def display_value(value):
    network = SA.main(value)
    fig = go.Figure(data=[go.Sankey(
    node = dict(
      pad = 15,
      thickness = 20,
      line = dict(color = "black", width = 0.5),
      label = network['node_labels'],
      color = "blue"
    ),
    link = dict(
      source = network['link_sources'], # indices correspond to labels, eg A1, A2, A2, B1, ...
      target = network['link_targets'],
      value = network['link_values']
    ))])
    fig.update_layout(title_text="Foucault's Christian Sources (threshold %d)" %value, font_size=10,height=700)
    return fig

if __name__ == '__main__':
	app.run_server(host='0.0.0.0', port=port, debug=True)