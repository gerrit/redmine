ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Allow Redmine plugins to map routes and potentially override them
  Rails.plugins.each do |plugin|
    map.from_plugin plugin.name.to_sym
  end

  map.home '', :controller => 'welcome'
  map.signin 'login', :controller => 'account', :action => 'login'
  map.signout 'logout', :controller => 'account', :action => 'logout'
  
  map.connect 'wiki/:id/:page/:action', :controller => 'wiki', :page => nil
  map.connect 'roles/workflow/:id/:role_id/:tracker_id', :controller => 'roles', :action => 'workflow'
  map.connect 'help/:ctrl/:page', :controller => 'help'
  #map.connect ':controller/:action/:id/:sort_key/:sort_order'
  
  map.connect 'issues/:issue_id/relations/:action/:id', :controller => 'issue_relations'

  map.connect 'boards/:board_id/topics/:action/:id', :controller => 'messages'

  map.connect 'projects/:project_id/issues/:action', :controller => 'issues'
  map.connect 'projects/:project_id/news/:action', :controller => 'news'
  map.connect 'projects/:project_id/documents/:action', :controller => 'documents'
  map.connect 'projects/:project_id/boards/:action/:id', :controller => 'boards'
  map.connect 'projects/:project_id/timelog/:action/:id', :controller => 'timelog', :project_id => /.+/
  map.connect 'projects/:id/members/new', :controller => 'members', :action => 'new'
  
  map.connect 'projects/:id/wiki', :controller => 'wikis', :action => 'edit', :conditions => {:method => :post}
  map.connect 'projects/:id/wiki/destroy', :controller => 'wikis', :action => 'destroy', :conditions => {:method => :get}
  map.connect 'projects/:id/wiki/destroy', :controller => 'wikis', :action => 'destroy', :conditions => {:method => :post}
  
  map.with_options :controller => 'projects' do |projects|
    projects.connect 'projects/:id/roadmap', :action => 'roadmap', :conditions => {:method => :get}
    
    projects.connect 'projects/:id/files', :action => 'list_files', :conditions => {:method => :get}
    projects.connect 'projects/:id/files/new', :action => 'add_file', :conditions => {:method => :get}
    projects.connect 'projects/:id/files/new', :action => 'add_file', :conditions => {:method => :post}
    
    projects.connect 'projects/:id/versions/new', :action => 'add_version', :conditions => {:method => :get}
    projects.connect 'projects/:id/versions/new', :action => 'add_version', :conditions => {:method => :post}

    projects.connect 'projects/:id/categories/new', :action => 'add_issue_category', :conditions => {:method => :get}
    projects.connect 'projects/:id/categories/new', :action => 'add_issue_category', :conditions => {:method => :post}
    
    projects.connect 'projects/:id/settings', :action => 'settings', :conditions => {:method => :get}
    projects.connect 'projects/:id/settings/:tab', :action => 'settings', :conditions => {:method => :get}
    
    # projects.connect 'projects', :action => 'index'
    # projects.connect 'projects/:id', :action => 'show'
    projects.with_options :action => 'activity', :conditions => {:method => :get} do |activity|
      activity.connect 'projects/:id/activity'
      activity.connect 'activity'
      activity.connect 'activity.:format'
    end
  end

  map.with_options :controller => 'repositories' do |omap|
    omap.repositories_show 'repositories/browse/:id/*path', :action => 'browse'
    omap.repositories_changes 'repositories/changes/:id/*path', :action => 'changes'
    omap.repositories_diff 'repositories/diff/:id/*path', :action => 'diff'
    omap.repositories_entry 'repositories/entry/:id/*path', :action => 'entry'
    omap.repositories_entry 'repositories/annotate/:id/*path', :action => 'annotate'
    omap.repositories_revision 'repositories/revision/:id/:rev', :action => 'revision'
  end
  
  map.connect 'attachments/:id', :controller => 'attachments', :action => 'show', :id => /\d+/
  map.connect 'attachments/:id/:filename', :controller => 'attachments', :action => 'show', :id => /\d+/, :filename => /.*/
  map.connect 'attachments/download/:id/:filename', :controller => 'attachments', :action => 'download', :id => /\d+/, :filename => /.*/
   
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

 
  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
