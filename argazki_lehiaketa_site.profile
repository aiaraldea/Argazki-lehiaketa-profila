<?php
// $Id: argazki_lehiaketa_site.profile,v 1.1.2.40 2010/09/14 18:57:57 alexb Exp $

/**
 * Implementation of hook_profile_details().
 */
function argazki_lehiaketa_site_profile_details() {
  return array(
    'name' => 'Argazki lehiaketa',
    'description' => 'Argazki lehiaketak egiteko ataria.'
  );
}

/**
 * Implementation of hook_profile_modules().
 */
function argazki_lehiaketa_site_profile_modules() {
  // Drupal core
  $modules = array(
    // Core modules
    'comment',      
    'help',
    'menu',            
    'path',      
    'taxonomy',
    'update',            
    'block',   
    'filter',
    'node',
    'system',
    'user', 
    'dblog',

 // Contrib        
    'imagecache',     
    'features',                  
    'imageapi',                  
    'imageapi_gd',            
    'imagecache_ui',        
    'advanced_help',        
    'follow',                      
    'forward',                    
    'helpinjector',         
    'pathauto',                  
    'strongarm',    
    'debut',                        
    'debut_admin',            
    'debut_social',                     
    'token',                        
    'panels_mini',            
    'panels',                      
    'forward_services',  
    'general_services',  
    'service_links',        
    'captcha',                    
    'views',                        
    'views_fluid_grid',  
    'views_ui',                    
    'admin',             
    'adminrole',    
    'content',         
    'email',             
    'filefield',     
    'imagefield',   
    'text',               
    'ctools',      
    'context',   
// Argazki lehiaketa
    'argazki_lehiaketa',
  );
  return $modules;
}


/**
 * Implementation of hook_profile_task_list().
 */
function argazki_lehiaketa_site_profile_task_list() {
  return array(
    'argazki_lehiaketa_site-configure' => st('Argazki lehiaketaren konfigurazioa'),
  );
}

/**
 * Implementation of hook_profile_tasks().
 */
function argazki_lehiaketa_site_profile_tasks(&$task, $url) {
  // Just in case some of the future tasks adds some output
  $output = '';

  if ($task == 'profile') {
/*     $modules = _argazki_lehiaketa_site_core_modules(); */
    $files = module_rebuild_cache();
    $operations = array();
    foreach ($modules as $module) {
      $operations[] = array('_install_module_batch', array($module, $files[$module]->info['name']));
    }
    $batch = array(
      'operations' => $operations,
      'finished' => '_argazki_lehiaketa_site_profile_batch_finished',
      'title' => st('Installing @drupal', array('@drupal' => drupal_install_profile_name())),
      'error_message' => st('The installation has encountered an error.'),
    );
    // Start a batch, switch to 'profile-install-batch' task. We need to
    // set the variable here, because batch_process() redirects.
    variable_set('install_task', 'profile-install-batch');
    batch_set($batch);
    batch_process($url, $url);
  }

  if ($task == 'argazki_lehiaketa_site-configure') {

    // Other variables worth setting.
    variable_set('site_footer', 'Powered by <a href="http://www.aiaraldea.com">Aiaraldea Komunikazio Leihoa</a>.');
    variable_set('site_frontpage', 'feeds');
    variable_set('comment_channel', 0);
    variable_set('comment_feed', 0);
    variable_set('comment_book', 0);

    // Clear caches.
    drupal_flush_all_caches();

    $task = 'finished';
  }

  return $output;
}

/**
 * Finished callback for the modules install batch.
 *
 * Advance installer task to language import.
 */
function _argazki_lehiaketa_site_profile_batch_finished($success, $results) {
  variable_set('install_task', 'mn-configure');
}

/**
 * Implementation of hook_form_alter().
 */
function argazki_lehiaketa_site_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    $form['site_information']['site_name']['#default_value'] = 'Argazki lehiaketa';
    $form['site_information']['site_mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];
    $form['admin_account']['account']['name']['#default_value'] = 'admin';
    $form['admin_account']['account']['mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];
  }
}

