# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Hydra::PolicyAwareAccessControlsEnforcement

  # These before_filters apply the hydra access controls
  #before_filter :enforce_show_permissions, :only=>:show
  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]
  #self.solr_search_params_logic = [:default_solr_parameters , :add_query_to_solr, :add_facet_fq_to_solr, :add_facetting_to_solr, :add_sorting_paging_to_solr ]

  def self.title_fields
    res = Solrizer.solr_name('title', :stored_sortable, type: :string)
    logger.info 'Solrizer results: ' + res.to_s

    res
  end

  configure_blacklight do |config|
    config.default_solr_params = {
        :qf => 'title_tesim title_ssm author_tesim description_tesim local_tesim imagetype_tesim category_tesim fileidentifier_tesim keywords_tesim id copyright_tesim',
        :qt => 'search',
        :rows => 10
    }

    # solr field configuration for search results/index views
    config.index.show_link = 'title_ssm'
    config.index.record_tsim_type = 'has_model_ssim'

    # solr field configuration for document/show views
    config.show.html_title = 'title_ssm'
    config.show.heading = 'title_ssm'
    config.show.display_type = 'has_model_ssim'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _tsimed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    config.add_facet_field solr_name('author', :facetable), :label => 'Ophav:', :limit => 11
    config.add_facet_field solr_name('person', :facetable), :label => 'Person:', :limit => 11

    #config.add_facet_field solr_name('author_tesim', :facetable, :show=>true), :label => 'Author'
    config.add_facet_field solr_name('category', :facetable), :label => 'Kategori:', :limit => 11
    config.add_facet_field solr_name('imagetype', :facetable), :label => 'Type:', :limit => 11
    config.add_facet_field solr_name('local', :facetable), :label => 'Område:', :limit => 11
    config.add_facet_field solr_name('keywords', :facetable), :label => 'Emneord:', :limit => 17
    config.add_facet_field solr_name('date_start', :facetable), :label => 'År:', :limit => 17


    config.add_facet_field solr_name('genre', :facetable), :label => 'Genre:', :limit => 11
    config.add_facet_field solr_name('copyright', :facetable), :label => 'License', :limit => 5

    #config.add_facet_field solr_name('category_tesim', :facetable, :show=>true), :label => 'Category'


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    # config.add_index_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:'
    config.add_index_field solr_name('title', :stored_searchable, type: :string), :label => 'Titel:'
    config.add_index_field solr_name('author', :stored_searchable, type: :string), :label => 'Forfatter'
    config.add_index_field solr_name('person', :stored_searchable, type: :string), :label => 'Person'
    config.add_index_field solr_name('fileidentifier', :stored_searchable, type: :string), :label => 'Fileidentifier'
    config.add_index_field solr_name('category', :stored_searchable, type: :string), :label => 'Kategori:'
    config.add_index_field solr_name('genre', :stored_searchable, type: :string), :label => 'Genre:'
    config.add_index_field solr_name('local', :stored_searchable, type: :string), :label => 'Område:'
    config.add_index_field solr_name('description', :stored_searchable, type: :string), :label => 'Beskrivelse:'
    config.add_index_field solr_name('imagetype', :stored_searchable, type: :string), :label => 'Type:'
    config.add_index_field solr_name('copyright', :stored_searchable, type: :string), :label => 'License:'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
=begin
    config.add_show_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:'
    config.add_show_field solr_name('author', :stored_searchable, type: :string), :label => 'Title:'
    config.add_show_field solr_name('fileidentifier', :stored_searchable, type: :string), :label => 'fileidentifier:'

    config.add_show_field solr_name('description', :stored_searchable, type: :string), :label => 'description:'

    config.add_show_field solr_name('imagetype', :symbol), :label => 'Imagetype:'
    config.add_show_field solr_name('url_fulltext_tsim', :stored_searchable, type: :string), :label => 'URL:'
    config.add_show_field solr_name('language', :stored_searchable, type: :string), :label => 'Language:'
    config.add_show_field solr_name('published', :stored_searchable, type: :string), :label => 'Published:'
    config.add_show_field solr_name('published_vern', :stored_searchable, type: :string), :label => 'Published:'
    config.add_show_field solr_name('lc_callnum', :stored_searchable, type: :string), :label => 'Call number:'
    config.add_show_field solr_name('isbn', :stored_searchable, type: :string), :label => 'ISBN:'
=end

    config.add_show_field solr_name('title', :stored_searchable, type: :string), :label => 'Titel:'
    config.add_show_field solr_name('author', :stored_searchable, type: :string), :label => 'Forfatter'
    config.add_show_field solr_name('person', :stored_searchable, type: :string), :label => 'Person'

    config.add_show_field solr_name('imagetype', :stored_searchable, type: :string), :label => 'Type:'
    config.add_show_field solr_name('category', :stored_searchable, type: :string), :label => 'Kategori:'
    config.add_show_field solr_name('keywords', :stored_searchable, type: :string), :label => 'Emneord:'
    config.add_show_field solr_name('genre', :stored_searchable, type: :string), :label => 'Genre:'
    config.add_show_field solr_name('local', :stored_searchable, type: :string), :label => 'Område:'
    config.add_show_field solr_name('date_txt', :stored_searchable, type: :string), :label => 'Tidspunkt:'
    config.add_show_field solr_name('date_start', :stored_searchable, type: :string), :label => 'År:'
    config.add_show_field solr_name('description', :stored_searchable, type: :string), :label => 'Beskrivelse:'
    config.add_show_field solr_name('fileidentifier', :stored_searchable, type: :string), :label => 'Fileidentifier'
    config.add_show_field solr_name('opstilling', :stored_searchable, type: :string), :label => 'Opstilling'
    config.add_show_field solr_name('copyright', :stored_searchable, type: :string), :label => 'License:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 

    config.add_search_field 'all_fields', :label => 'Alt'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 

    config.add_search_field('Titel') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
      #field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = Solrizer.solr_name("title", :stored_searchable, type: :string)
      field.solr_local_parameters = {
          :qf => solr_name,
          :pf => solr_name
      }
    end

    config.add_search_field('Forfatter') do |field|
      solr_name = Solrizer.solr_name("author", :stored_searchable, type: :string)
      field.solr_local_parameters = {
          :qf => solr_name,
          :pf => solr_name
      }
    end

    config.add_search_field('Område') do |field|
      solr_name = Solrizer.solr_name("local", :stored_searchable, type: :string)
      field.solr_local_parameters = {
          :qf => solr_name,
          :pf => solr_name
      }
    end

    config.add_search_field('Kategori') do |field|
      solr_name = Solrizer.solr_name("category", :stored_searchable, type: :string)
      field.solr_local_parameters = {
          :qf => solr_name,
          :pf => solr_name
      }
    end

    config.add_search_field('License') do |field|
      solr_name = Solrizer.solr_name("copyright", :stored_searchable, type: :string)
      field.solr_local_parameters = {
          :qf => solr_name,
          :pf => solr_name
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as 
    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
=begin
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = { 
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end
=end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc', :label => 'Relevans'
    config.add_sort_field 'title_si asc', :label => 'Titel'
    config.add_sort_field 'title_si desc', :label => 'Titel (Å->A)'

    config.add_sort_field 'author_si asc', :label => 'Forfatter'
    config.add_sort_field 'author_si desc', :label => 'Forfatter (Å->A)'
    config.add_sort_field 'imagetype_si asc', :label => 'Type'
    config.add_sort_field 'imagetype_si desc', :label => 'Type (Å->A)'
    config.add_sort_field 'category_si asc', :label => 'Kategori'
    config.add_sort_field 'category_si desc', :label => 'Kategori (Å->A)'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end
