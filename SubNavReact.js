/*  Mindset Poetry
Sub navigation for groupings of poems 
Original build 11-12-15 by je
Update for 2016, 01-04-16 by je
*/

var Poemnav = React.createClass({

    getInitialState: function(){
        return { focused: 0 };
    },

    clicked: function(index){

        // The click handler will update the state with
        // the index of the focused menu entry

        this.setState({focused: index});
    },

    render: function() {

        // Here we will read the items property, which was passed
        // as an attribute when the component was created

        var self = this;

        // The map method will loop over the array of menu entries,
        // and will return a new array with <li> elements.

        return ( <div>
                <ul>{ this.props.items.map(function(item, index){
        
                    var style = '';
        
                    if(self.state.focused == index){
                        style = 'focused';
                    }
        
                    // Notice the use of the bind() method. It makes the
                    // index available to the clicked function:
        
                    return <li className={style} key={index} data={item} onClick={self.clicked.bind(self, index)}>{item}</li>;
        
                }) }
                        
                </ul>
                
              
            </div> );

    }
});

// Render the menu component on the page, and pass an array with menu options

React.render(
    <Poemnav items={ [<a href="#all" >All Poems</a>, <a href="#poems2016" class="2016">2016</a>,  <a href="#poems2015" class="2015">2015</a>, <a href="#poems2014" class="2014">2014</a>, <a href="#poems2013" class="2013">2013</a>, <a href="#poems2012" class="2012">2012</a>, <a href="#poems2011" class="2011">2011</a>, <a href="#poems2010" class="2010">2010</a>, <a href="#poems2009" class="2009">2009</a>,  <a href="#poemsOther" class="Other">Other</a>] } />,
  document.getElementById('poemnav'));
