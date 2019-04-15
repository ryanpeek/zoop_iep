tabPanel("About",
  h2("About this application"),
  HTML(
  '<p style="text-align:justify">This web application uses Zooplankton IEP data from CDFW, collected since 1972. For more information, please see this webpage <a href="http://www.dfg.ca.gov/delta/projects.asp?ProjectID=ZOOPLANKTON" target=_blank>CDFW.</a> Shiny applications are dynamic and allow for interactivity between the user and the data. This app has been adapted from code written by <a href="https://leonawicz.github.io/apps.html" target=_blank>Matt Leonawicz</a> as part of his <a href="https://github.com/ua-snap/shiny-apps/tree/master/cc4liteFinal" target=_blank>CC4lite</a> app.</p>'),
  
  HTML('
  <div style="clear: left;"><img src="https://watershed.ucdavis.edu/files/styles/medium/public/images/users/P1010393_0.JPG?itok=IjCQNxiD" alt="" style="float: left; margin-right:5px" /></div>
              <p>Ryan Peek, PhD<br/>
              Aquatic Ecologist at the Center for Watershed Sciences, UC Davis<br/>
              <a href="https://twitter.com/riverpeek" target="_blank">Twitter</a> | 
              <a href="http://watershed.ucdavis.edu/", target="_blank">Center for Watershed Sciences</a> | 
              <a href="https://github.com/ryanpeek", target="_blank">Github</a>
              </p>'),

         fluidRow(
           column(4,
                  HTML('<strong>Source Code on Github</strong>
                      <ul>
                      <li><a href="https://github.com/ucd-cws", target="_blank">CWS Code</a></li>
                      </ul>')
           )
         ),


         fluidRow(
           column(4,
                  HTML('<strong>References</strong>
                       <p></p><ul>
                       <li><a href="http://www.r-project.org/" target="_blank">Coded in R</a></li>
                       <li><a href="http://www.rstudio.com/shiny/" target="_blank">Built with the Shiny package</a></li>
                       <li>Additional supporting R packages</li>
                       <ul>
                       <li><a href="http://rstudio.github.io/shinythemes/" target="_blank">shinythemes</a></li>
                       <li><a href="https://github.com/ebailey78/shinyBS" target="_blank">shinyBS</a></li>
                       <li><a href="http://rstudio.github.io/leaflet/" target="_blank">leaflet</a></li>
                       </ul>')
           )
         ),
         value="about"
)
