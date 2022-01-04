package com.nicico.training.model;

import lombok.*;
import lombok.experimental.Accessors;

import javax.persistence.*;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@EqualsAndHashCode(of = {"id"}, callSuper = false)
@Entity
@Table(name = "tbl_file_label")
public class FileLabel extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "file_label_seq")
    @SequenceGenerator(name = "file_label_seq", sequenceName = "seq_file_Label_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_label_name", nullable = false)
    private String labelName;

    @ManyToMany(mappedBy = "fileLabels")
    private Set<HelpFiles> helpFiles;

}
