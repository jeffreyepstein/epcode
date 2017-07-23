
//...just an excerpt to show use of WP functions

			while (have_posts()) : the_post();	?>

			<div class="grid-item">
				
				<?php
					$term_list = wp_get_post_terms($post->ID, 'category', array("fields" => "all"));

					foreach($term_list as $term_single) {
						$thispost_category = $term_single->slug;
					}
					echo '<div class="post ' . $thispost_category .'">'; //creates custom class for styling purposes
				 ?>
				<h4><?php the_category() ?> </h4><!-- function create ul and li on the fly -->
				
					<div class = "post-contents">
						<a href="<?php the_permalink(); ?>">
						  <?php
							$featuredImage = get_the_post_thumbnail($post->ID, 'full');
							echo $featuredImage;
						  ?>
					
						<h2><?php the_title(); ?></h2>
						</a>
//...