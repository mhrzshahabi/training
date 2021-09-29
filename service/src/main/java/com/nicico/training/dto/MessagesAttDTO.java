package com.nicico.training.dto;


import lombok.Data;

@Data
public class MessagesAttDTO {
        private String context;
        private String groupId;
        private Boolean deleted;
        private String title;
}
