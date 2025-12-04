package com.pbw.MusicApp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
public class MusicAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(MusicAppApplication.class, args);
	}

	@GetMapping("/login")
	public String login() {
		return "login";
	}
}
