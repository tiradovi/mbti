package com.mbti.answer.model.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Answer {
    private Long id;
    private Long resultId;
    private Long questionId;
    private String selectedOption;
    private String selectedType;
    private String createdAt;
}
