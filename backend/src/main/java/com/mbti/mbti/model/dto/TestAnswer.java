package com.mbti.mbti.model.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class TestAnswer {
    private Long questionId;
    private String selectedOption;
}