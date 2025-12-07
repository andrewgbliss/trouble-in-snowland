class_name ImageUtils extends Node

static func load_image(path: String):
	var image = Image.load_from_file(path)
	return image

static func save_image(image: Image, path: String):
	image.save_png(path)

static func get_current_texture_from_animated_sprite(animated_sprite: AnimatedSprite2D, sprite_frames: SpriteFrames):
	var current_animation = animated_sprite.animation
	var current_frame = animated_sprite.frame
	var current_frame_texture = sprite_frames.get_frame_texture(current_animation, current_frame)
	
	# Ensure alpha is preserved by converting to RGBA8 format
	var image = current_frame_texture.get_image()
	# Convert to RGBA8 format to ensure alpha channel is preserved
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)
	
	# Create a new ImageTexture with alpha support
	var texture_with_alpha = ImageTexture.create_from_image(image)
	return texture_with_alpha

static func get_bitmap(texture: Texture2D):
	var image = texture.get_image()
	var used_rect = image.get_used_rect()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image, used_rect)
	return bitmap

static func get_polygons(texture: Texture2D):
	var bitmap = get_bitmap(texture)
	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()))
	return polys

static func get_center(texture: Texture2D):
	var bitmap = get_bitmap(texture)
	return bitmap.get_size() / 2

static func get_image_used_rect(texture: Texture2D):
	var image = texture.get_image()
	return image.get_used_rect()

static func get_bounds_of_alpha(texture: Texture2D):
	var bitmap = get_bitmap(texture)
	print("Bitmap size:", bitmap.get_size())
	var top = - bitmap.get_size().y / 2.0
	var bottom = bitmap.get_size().y / 2.0
	var left = - bitmap.get_size().x / 2.0
	var right = bitmap.get_size().x / 2.0
	return Rect2(left, top, right - left, bottom - top)

static func get_collision_polygon(texture: Texture2D, centered: bool = false):
	var polygons = get_polygons(texture)
	var center = get_center(texture)
	var collision_polygons = []
	for poly in polygons:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		collision_polygons.append(collision_polygon)
		if centered:
			collision_polygon.position -= center
	return collision_polygons
