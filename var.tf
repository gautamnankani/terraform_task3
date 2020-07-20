variable "Profile_name" {
    type = string
    description = "Profile name"
    default = "myprofile"
}

//NOTE: availability zone and Region are dependent on each other
// So if you cahnge one the change other
variable "Region_name" {
    type = string
    description = "Region name"
    default = "ap-south-1"
}

variable "PublicSubnet_AvailabilityZone" {
    type = string
    description = "Availability zone(Inside above Region) for Public Subnet"
    default = "ap-south-1a"
}

variable "PrivateSubnet_AvailabilityZone" {
    type = string
    description = "Availability zone(Inside above Region) for Private Subnet"
    default = "ap-south-1b"
}


// These are ami created by me,
// so you may not find it publicly but you can use some public ami 
//or can make it by yourself, using various docs availaible online 
variable "mysql_ami" {
    type = string
    description = "Mysql ami name"
    default = "ami-0e18cc6022b19cde1"
}

variable "wordpress_ami" {
    type = string
    description = "Wordpress ami name"
    default = "ami-081545ade3dff9b59"
}