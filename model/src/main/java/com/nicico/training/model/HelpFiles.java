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
@Table(name = "tbl_help_files")
public class HelpFiles extends Auditable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "help_files_seq")
    @SequenceGenerator(name = "help_files_seq", sequenceName = "seq_help_files_id", allocationSize = 1)
    @Column(name = "id", precision = 10)
    private Long id;

    @Column(name = "c_file_name", nullable = false)
    private String fileName;

    @Column(name = "c_description")
    private String description;

    @Column(name = "group_id")
    private String group_id;

    @Column(name = "key")
    private String key;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "TBL_HELP_FILES_LABEL",
            joinColumns = {@JoinColumn(name = "F_HELP_FILES", referencedColumnName = "id")},
            inverseJoinColumns = {@JoinColumn(name = "F_FILE_LABEL", referencedColumnName = "id")})
    private Set<FileLabel> fileLabels;
}
